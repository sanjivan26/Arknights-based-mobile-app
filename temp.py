import DijkstraPathfinder

data = [

    ['6', 'A'],
    ['A', 'B',  'C', 'D', 'E', 'F'],
    ['A', 'B', '2', '0'],
    ['A', 'D', '8', '0'],
    ['B', 'D', '5', '0'],
    ['B', 'E', '6', '0'],
    ['D', 'E', '3', '0'],
    ['D', 'F', '2', '0'],
    ['E', 'F', '1', '0'],
    ['E', 'C', '9', '0'],
    ['F', 'C', '3', '0']
]

table = DijkstraPathfinder.run(data)
print(table)
print("Shortest Path From C:", DijkstraPathfinder.get_path(table, 'C'))