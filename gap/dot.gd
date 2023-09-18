# LoadPackage("digraphs");
# JDM this is not the correct place to do this, if the package depends on
# another package, then this should go in the PackageInfo.g file.
# In any case, Digraphs should be dependent on this package not the other way
# around.

# declare data categories / families / types
DeclareCategory("IsGVObject", IsObject);
DeclareCategory("IsGVGraphOrDigraph", IsGVObject);
DeclareCategory("IsGVGraph", IsGVGraphOrDigraph);
DeclareCategory("IsGVDigraph", IsGVGraphOrDigraph);

DeclareCategory("IsGVNode", IsGVObject);
DeclareCategory("IsGVEdge", IsGVObject);

# Constructors
DeclareConstructor("GV_MakeViz", [IsGVObject]);
DeclareOperation("GV_MakeGraph", [IsString]);
DeclareOperation("GV_MakeNode", [IsString]);
DeclareOperation("GV_MakeEdge", [IsGVNode, IsGVNode]);

# TODO please lose the Get and Set in the below.

# Getters
DeclareOperation("GV_GetEdges", [IsGVGraph]);
DeclareOperation("GV_GetEdge", [IsGVNode, IsGVNode]);

# TODO what would this do exactly?
DeclareOperation("GV_GetEdge", [IsString, IsString]);
DeclareOperation("GV_GetName", [IsGVObject]);
DeclareOperation("GV_GetLabel", [IsGVObject]);
DeclareOperation("GV_GetAttrs", [IsGVObject]);
DeclareOperation("GV_GetNodes", [IsGVObject]);
DeclareOperation("GV_GetNode", [IsGVObject, IsString]);
DeclareOperation("GV_GetComments", [IsGVObject]);

# Setters
DeclareOperation("GV_SetName", [IsGVObject, IsString]);
DeclareOperation("GV_SetLabel", [IsGVObject, IsString]);
# TODO would it make sense to call this on a node or an edge?
DeclareOperation("GV_SetAllNodeStyle", [IsGVObject, IsString]);
# TODO would it make sense to call this on a node or an edge?
DeclareOperation("GV_SetAllNodeColor", [IsGVObject, IsString]);

DeclareOperation("GV_GetEdge", [IsGVGraph, IsGVNode, IsGVNode]);
DeclareOperation("GV_GetEdge", [IsGVGraph, IsString, IsString]);
DeclareOperation("GV_GetEdge", [IsGVObject, IsGVNode, IsGVNode]);
DeclareOperation("GV_GetSubgraph", [IsGVObject, IsString]);
DeclareOperation("GV_GetSubgraphs", [IsGVGraph]);


# Mutating Methods
DeclareOperation("GV_AddNode", [IsGVObject, IsGVNode]);
DeclareOperation("GV_AddNode", [IsGVObject, IsString]);

DeclareOperation("GV_AddEdge", [IsGVObject, IsGVEdge]);
DeclareOperation("GV_AddEdge", [IsGVObject, IsGVNode, IsGVNode]);
DeclareOperation("GV_AddEdge", [IsGVGraph, IsString, IsString]);

DeclareOperation("GV_RemoveNode", [IsGVObject, IsGVNode]);
DeclareOperation("GV_RemoveNode", [IsGVObject, IsString]);

DeclareOperation("GV_RemoveEdge", [IsGVObject, IsGVEdge]);
DeclareOperation("GV_RemoveEdge", [IsGVObject, IsGVNode, IsGVNode]);
DeclareOperation("GV_RemoveEdge", [IsGVObject, IsString, IsString]);

DeclareOperation("GV_AddSubgraph", [IsGVObject, IsGVGraph]);
DeclareOperation("GV_RemoveSubgraph", [IsGVObject, IsString]);

DeclareOperation("GV_AddAttr", [IsGVObject, IsString, IsString]);
DeclareOperation("GV_ClearAttr", [IsGVObject, IsString]);
DeclareOperation("GV_AddNodeAttr", [IsGVGraph, IsString, IsString]);
DeclareOperation("GV_ClearNodeAttr", [IsGVGraph, IsString]);
DeclareOperation("GV_AddEdgeAttr", [IsGVGraph, IsString, IsString]);
DeclareOperation("GV_ClearEdgeAttr", [IsGVGraph, IsString]);
# output
DeclareOperation("GV_DotDigraph", [IsDigraph]);
DeclareOperation("GV_ToDot", [IsGVGraph]);
DeclareOperation("GV_ToGV", [IsDigraph]);

# Testing
DeclareOperation("TestCode", []);
