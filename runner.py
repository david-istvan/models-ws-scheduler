import itertools
from minizinc import Instance, Model, Solver

workshops = ['DevOps', 'HuFaMo', 'LowCode', 'MASE', 'MDEIntelligence', 'ME', 'MLE', 'MoDDiT', 'MoDeVVa', 'MPM4CPS', 'MULTI', 'OCL']
days = ['Sunday', 'Monday', 'Tuesday']

def listToMinizincEnum(pythonList):
    return str(pythonList).replace("'", "").replace("[", "{").replace("]", "}")


gecode = Solver.lookup("gecode")
model = Model("./modelsws-python.mzn")
model.add_file("ws2022.dzn")
model.add_string('WORKSHOP = {};\n'.format(listToMinizincEnum(workshops)))
model.add_string('DAY = {};\n'.format(listToMinizincEnum(days)))
instance = Instance(gecode, model)

with instance.branch() as findMax:
    findMax.add_string('solve maximize GOAL;\n')
    result = findMax.solve()
    satisfactionRatio = result['satisfactionRatio']

print(
    'Found optimal satisfactionRatio={}.\n'
    'Generating all solutions.\n'.format(satisfactionRatio)
)

instance.add_string(
    '''
    constraint satisfactionRatio >= {};\n
    solve satisfy;\n
    '''.format(satisfactionRatio)
)
result = instance.solve(all_solutions=True)

allocations = [solution.allocation for solution in result.solution]
allocations.sort()
allocations = list(allocations for allocations,_ in itertools.groupby(allocations))

for allocation in allocations:
    for index, workshop in enumerate(workshops):
        print('{0:20} {1}'.format(workshop, allocation[index]))        
    print('========================')