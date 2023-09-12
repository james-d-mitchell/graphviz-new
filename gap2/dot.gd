
# declare data categories / families / types
DeclareCategory("IsGVObject", IsObject);
DeclareCategory("IsGVGraph", IsGVObject);
DeclareCategory("IsGVNode", IsGVObject);
DeclareCategory("IsGVEdge", IsGVObject);

# constructors
DeclareConstructor("GV_MakeViz", [IsGVObject]);
DeclareOperation("GV_MakeGraph", [IsString]);
DeclareOperation("GV_MakeNode", [IsString]);
DeclareOperation("GV_MakeEdge", [IsGVNode, IsGVNode]);

# attributes
# DeclareAttribute("GV_Edges", IsGVObject, "mutable");
# DeclareAttribute("GV_Name", IsGVObject, "mutable");
# DeclareAttribute("GV_Nodes", IsGVObject, "mutable");
# DeclareAttribute("GV_Comments", IsGVObject, "mutable");
# DeclareAttribute("GV_Lines", IsGVObject, "mutable");


# Getters
DeclareOperation("GV_GetEdges", [IsGVObject]);
DeclareOperation("GV_GetEdge", [IsGVNode, IsGVNode]);
DeclareOperation("GV_GetEdge", [IsString, IsString]);
DeclareOperation("GV_GetName", [IsGVObject]);
DeclareOperation("GV_GetLabel", [IsGVObject]);
DeclareOperation("GV_GetNodes", [IsGVObject]);
DeclareOperation("GV_GetNode", [IsGVObject, IsString]);
DeclareOperation("GV_GetComments", [IsGVObject]);

# Setters
DeclareOperation("GV_SetName", [IsGVObject, IsString]);
DeclareOperation("GV_SetLabel", [IsGVObject, IsString]);
DeclareOperation("GV_SetAllNodeStyle", [IsGVObject, IsString]);
DeclareOperation("GV_SetAllNodeColor", [IsGVObject, IsString]);

DeclareOperation("GV_GetEdge", [IsGVGraph, IsGVNode, IsGVNode]);
DeclareOperation("GV_GetEdge", [IsGVGraph, IsString, IsString]);
DeclareOperation("GV_GetEdge", [IsGVObject, IsGVNode, IsGVNode]);
DeclareOperation("GV_GetNode", [IsGVObject, IsString]);
DeclareOperation("GV_GetSubgraph", [IsGVObject, IsString]);


# Mutating Methods
DeclareOperation("GV_AddNode", [IsGVObject, IsGVNode]);
DeclareOperation("GV_AddNode", [IsGVObject, IsString]);

DeclareOperation("GV_AddEdge", [IsGVObject, IsGVEdge]);
DeclareOperation("GV_AddEdge", [IsGVObject, IsGVNode, IsGVNode]);


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
DeclareOperation("GV_ToDot", [IsGVGraph]);
