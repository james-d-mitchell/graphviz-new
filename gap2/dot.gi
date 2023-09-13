###############################################################################
# Family + type
###############################################################################

BindGlobal(
  "GV_ObjectFamily",
  NewFamily("GV_ObjectFamily", IsGVObject)
);

BindGlobal("GV_GraphType", NewType(GV_ObjectFamily,
                                   IsGVGraph and
                                   IsComponentObjectRep and
                                   IsAttributeStoringRep));

BindGlobal("GV_NodeType", NewType(
    GV_ObjectFamily,
    IsGVNode and IsComponentObjectRep and IsAttributeStoringRep
));

BindGlobal("GV_EdgeType", NewType(
    GV_ObjectFamily,
    IsGVEdge and IsComponentObjectRep and IsAttributeStoringRep
));

# Private Helpers
DeclareOperation("GV_AppendIfAbsent", [IsList, IsObject]);
InstallMethod(GV_AppendIfAbsent, [IsList, IsObject],
function(list, value)
    if not (value in list) then
        Append(list, [value]);
    fi;
    return list;
end);

# Constructors
InstallMethod(GV_MakeNode, [IsString],
function(name)
    return Objectify(GV_NodeType,
        rec(
            name := name,
            attrs := [],
        )
    );
end);

InstallMethod(GV_MakeGraph, "Creates a new GV Graph with the given name.", [IsString],
function(name)
    return Objectify(GV_GraphType,
        rec(
            name := name,
            nodes := rec(),
            edges := [],
            subgraphs := rec(),
            attrs:=[],
            nodeAttrs:=[],
            edgeAttrs:=[]
    ));
end);

# Getters
# TODO Maybe add recursive get edges for subgraphs
InstallMethod(GV_GetNode, [IsGVObject, IsString],
function(graph, nodeName)
    return graph!.nodes.(nodeName);
end);

InstallMethod(GV_GetSubgraph, [IsGVObject, IsString],
function(graph, subName)
    return graph!.subgraphs.(subName);
end);

InstallMethod(GV_GetEdges, [IsGVObject],
function(graph)
    return graph!.edges;
end);

InstallMethod(GV_GetName, [IsGVObject], 
function(obj)
    return obj!.name;
end);

InstallMethod(GV_GetNodes, [IsGVObject], 
function(obj)
    return obj!.nodes;
end);

InstallMethod(GV_GetComments, [IsGVObject], 
function(obj)
    return obj!.comments;
end);

InstallMethod(GV_GetLabel, [IsGVObject],
function(graph)
    return graph!.label;
end);

# Setters
InstallMethod(GV_SetName, [IsGVObject, IsString],
function(graph, newName)
    graph!.name := newName;
end);

InstallMethod(GV_SetLabel, [IsGVObject, IsString],
function(graph, label)
    graph!.label := label;
end);

InstallMethod(GV_SetNodeStyle, [IsGVObject, IsString],
function(graph, style)
    graph!.nodeStyle.style := style;
end);

InstallMethod(GV_SetNodecolor, [IsGVObject, IsString],
function(graph, color)
    graph!.nodeStyle.color := color;
end);

InstallMethod(GV_GetSubgraphs, [IsGVGraph], x -> x!.subgraphs);


# Mutating Methods

######################################################################
# Make Edge
######################################################################
InstallMethod(GV_MakeEdge, [IsGVNode, IsGVNode],
function(head, tail)
    return Objectify(GV_EdgeType,
        rec(
            head := head,
            tail := tail,
            attrs:=[],
        )
    );
end);

######################################################################
# Add Node
######################################################################
InstallMethod(GV_AddNode, [IsGVGraph, IsGVNode],
function(graph, node)
    local nodeName;
    nodeName := node!.name;
    GV_GetNodes(graph).(nodeName) := node; 
    return node;
end);

InstallMethod(GV_AddNode, [IsGVGraph, IsString],
function(graph, nodeName)
    local node;
    node := GV_MakeNode(nodeName);
    GV_GetNodes(graph).(nodeName) := node;
    return node; 
end);


#####################################################################
# Equality Testing
#####################################################################
DeclareOperation("GV_NodeEq", [IsGVNode, IsGVNode]);
InstallMethod(GV_NodeEq, [IsGVNode, IsGVNode],
function(node1, node2)
    return node1!.name = node2!.name;
end);

DeclareOperation("GV_EdgeEq", [IsGVEdge, IsGVEdge]);
InstallMethod(GV_EdgeEq, [IsGVEdge, IsGVEdge],
function(edge1, edge2)
    local h1, t1, h2, t2;
    h1 := edge1!.head;
    t1 := edge1!.tail;
    h2 := edge2!.head;
    t2 := edge2!.tail;
    return GV_NodeEq(h1, h2) and GV_NodeEq(t1, t2);
end);

######################################################################
# Remove Node
######################################################################
InstallMethod(GV_RemoveNode, [IsGVGraph, IsString],
function(graph, nodeName)
    local edges, i, head, tail, c1, c2;

    # remove node from the nodes
    Unbind(graph!.nodes.(nodeName));

    # remove all edges where the tail or head is the node
    edges := graph!.edges;
    for i in [1..Size(edges)] do
        head := edges[i]!.head;
        tail := edges[i]!.tail;
        c1 :=  head!.name = nodeName;
        c2 :=  tail!.name = nodeName;
        if c1 or c2 then
            Unbind\[\](edges, i);
        fi;
    od;    
end);

InstallMethod(GV_RemoveNode, [IsGVGraphType, IsGVNode],
function(graph, node)
    GV_RemoveNode(graph, node!.name);
end);
######################################################################

DeclareOperation("GV_HasNode", [IsGVGraph, IsGVNode]);
InstallMethod(GV_HasNode, [IsGVGraph, IsGVNode],
function(graph, node)
    return IsBound(graph!.nodes.(node!.name));
end);


######################################################################
# Add Edge
######################################################################
InstallMethod(GV_AddEdge, [IsGVGraph, IsGVEdge],
function(graph, edge)
    local head, tail;
    tail := edge!.tail;
    head := edge!.head;

    # add nodes if they are not already added
    if not GV_HasNode(graph, head) then
        GV_AddNode(graph, head);
    fi;
    if not GV_HasNode(graph, tail) then
        GV_AddNode(graph, tail);
    fi;

    # make/add the edge
    Append(graph!.edges, [edge]);
    return edge;
end);

InstallMethod(GV_AddEdge, [IsGVGraph, IsGVNode, IsGVNode],
function(graph, head, tail)
    return GV_AddEdge(graph, GV_MakeEdge(head, tail));
end);

######################################################################
# Remove Edge
######################################################################
InstallMethod(GV_RemoveEdge, [IsGVGraph, IsGVEdge],
function(graph, edge)
    local i, edges, temp;
    edges := graph!.edges;
    for i in [1..Size(edges)] do
        temp := edges[i];
        if GV_EdgeEq(temp, edge) then
            Unbind\[\](edges, i);
        fi;
    od;
end);

InstallMethod(GV_RemoveEdge, [IsGVGraph, IsGVNode, IsGVNode],
function(graph, head, tail)
    local edge;
    edge := GV_MakeEdge(head, tail);
    GV_RemoveEdge(graph, edge);
end);

InstallMethod(GV_RemoveEdge, [IsGVGraph, IsString, IsString],
function(graph, headName, tailName)
    local head, tail;
    head := GV_MakeNode(headName);
    tail := GV_MakeNode(tailName);
    GV_RemoveEdge(graph, head, tail);
end);

######################################################################
# Add Subgraph
######################################################################
InstallMethod(GV_AddSubgraph, [IsGVObject, IsGVGraph],
function(graph, subGraph)
    local subName;
    subName := subGraph!.name;
    graph!.subgraphs.(subName) := subGraph;
end);


######################################################################
# Remove Subgraph
######################################################################
InstallMethod(GV_RemoveSubgraph, [IsGVObject, IsString],
function(graph, subName)
    Unbind(graph!.subgraphs.(subName));
end);


#####################################################################
# Get Attrs
#####################################################################
InstallMethod(GV_GetAttrs, [IsGVGraph],
function(graph)
    return graph!.attrs;
end);

DeclareOperation("GV_GetAttrs", [IsGVEdge]);
InstallMethod(GV_GetAttrs, [IsGVEdge],
function(edge)
    return edge!.attrs;
end);

DeclareOperation("GV_GetAttrs", [IsGVNode]);
InstallMethod(GV_GetAttrs, [IsGVNode],
function(node)
    return node!.attrs;
end);

#####################################################################
# Add Attrs
#####################################################################
InstallMethod(GV_AddAttr, [IsGVObject, IsString, IsString],
function(obj, attr, value)
    Append(GV_GetAttrs(obj), [rec(key:=attr, value:=value)]);
end);

InstallMethod(GV_AddNodeAttr, [IsGVGraph, IsString, IsString],
function(graph, attr, value)
    Append(graph!.nodeAttrs, [rec(key:=attr, value:=value)]);
end);

InstallMethod(GV_AddEdgeAttr, [IsGVGraph, IsString, IsString],
function(graph, attr, value)
    Append(graph!.edgeAttrs, [rec(key:=attr, value:=value)]);
end);

#####################################################################
# Clear Attr
#####################################################################
InstallMethod(GV_ClearAttr, [IsGVObject, IsString],
function(obj, attr)
    GV_AddAttr(obj, attr, "");
end);

InstallMethod(GV_ClearNodeAttr, [IsGVGraph, IsString],
function(obj, attr)
    GV_AddNodeAttr(obj, attr, "");
end);

InstallMethod(GV_ClearEdgeAttr, [IsGVGraph, IsString],
function(obj, attr)
    GV_AddEdgeAttr(obj, attr, "");
end);

#####################################################################
# Get Edge
#####################################################################
InstallMethod(GV_GetEdge, "Hello World", [IsGVGraph, IsString, IsString],
function(graph, headName, tailName)
    local tm, hm, edge, edges;
    edges := graph!.edges;
    for edge in edges do
        hm := GV_GetName(edge!.head) = headName;
        tm := GV_GetName(edge!.tail) = tailName;
        if hm and tm then
            return edge;
        fi; 
    od;
    return fail;
end);


InstallMethod(GV_GetEdge, [IsGVObject, IsGVNode, IsGVNode],
function(graph, headNode, tailNode)
    local tailName, headName;
    tailName := GV_GetName(tailNode);
    headName := GV_GetName(headNode);
    return GV_GetEdge(graph, headName, tailName);
end);


######################################################################
# To Dot
######################################################################

DeclareOperation("GV_GetEdges", [IsGVGraph]);
InstallMethod(GV_GetEdges, [IsGVGraph],
function(graph)
    return graph!.edges;
end);

DeclareOperation("GV_AttrToString", [IsRecord]);
InstallMethod(GV_AttrToString, [IsRecord],
function(attr)
    return StringFormatted("{}=\"{}\"", attr!.key, attr!.value);
end);

DeclareOperation("GV_CollapseAttrs", [IsList]); 
InstallMethod(GV_CollapseAttrs, [IsList], 
function(attrs)
    local output, attr;
    output := "[";
    for attr in attrs do
        Append(output, GV_AttrToString(attr));
        Append(output, ",");
    od;
    Append(output, "]");
    return output;
end);

# Convert an edge to a string
DeclareOperation("GV_EdgeToString", [IsGVEdge]);
InstallMethod(GV_EdgeToString, [IsGVEdge],
function(edge)
    local output, attrs;
    output := "";

    # make main arrow part
    Append(output, GV_GetName(edge!.head));
    Append(output, " -> ");
    Append(output, GV_GetName(edge!.tail));
    
    # make attribute section
    attrs := GV_GetAttrs(edge);
    Append(output, GV_CollapseAttrs(attrs));

    Append(output, ";");
    return output;
end);

DeclareOperation("GV_NodeToString", [IsGVNode]);
InstallMethod(GV_NodeToString, [IsGVNode],
function(node)
    local output, attrs;
    output := ""; 
    attrs := GV_GetAttrs(node);
    Append(output, GV_GetName(node));
    Append(output, GV_CollapseAttrs(attrs));
    Append(output, ";");
    return output;
end);

DeclareOperation("Quote", [IsObject]);
InstallMethod(Quote, [IsObject],
function(v)
    return StringFormatted("\"{}\"", v);
end);

DeclareOperation("GV_ToDotHelp", [IsGVGraph, IsBool]);
InstallMethod(GV_ToDotHelp, [IsGVGraph, IsBool],
function(graph, isSubgraph)
    local graphType, output, edge, nodeName, subName, subgraphs, attr, node, nodes;
    output := "";
    
    if isSubgraph then
        graphType := "subgraph";
    else
        graphType := "digraph";
    fi;

    # line 1
    Append(output, graphType);
    Append(output, " ");
    Append(output, Quote(GV_GetName(graph)));
    Append(output, " {\n");

    # Graph attrs
    for attr in GV_GetAttrs(graph) do
        Append(output, "\t");
        Append(output, GV_AttrToString(attr));
        Append(output, ";\n");
    od;

    # global node attrs
    Append(output, "\tnode");
    Append(output, GV_CollapseAttrs(graph!.nodeAttrs));
    Append(output, ";\n");

    # global edge attrs
    Append(output, "\tedge");
    Append(output, GV_CollapseAttrs(graph!.edgeAttrs));
    Append(output, ";\n");

    # subgraphs
    subgraphs := GV_GetSubgraphs(graph);
    Append(output, "\n");
    for subName in RecNames(subgraphs) do
        Append(output, GV_ToDotHelp(subgraphs.(subName), true));
        Append(output, "\n"); 
    od;

    # edges
    for edge in GV_GetEdges(graph) do
        Append(output, "\n\t");
        Append(output, GV_EdgeToString(edge));
    od;

    # nodes
    nodes := GV_GetNodes(graph);
    for nodeName in RecNames(nodes) do
        node := nodes.(nodeName);
        Append(output, "\n\t");
        Append(output, GV_NodeToString(node));
    od;

    Append(output, "\n}");
    return output;

end);

InstallMethod(GV_ToDot, [IsGVGraph], 
function(graph)
    local output;
    output := "";
    Append(output, GV_ToDotHelp(graph, false));
    return output;
end);

test := GV_MakeGraph("Test Graph");
GV_GetName(test);
GV_GetNodes(test);
a0 := GV_MakeNode("a0");
GV_AddNode(test, a0);
a1 := GV_AddNode(test, "a1");
a2 := GV_AddNode(test, "a2");
a3 := GV_AddNode(test, "a3");
a4 := GV_AddNode(test, "a4");
a5 := GV_AddNode(test, "a5");
et := GV_MakeEdge(GV_MakeNode("c1"), GV_MakeNode("c2"));
GV_AddAttr(et, "color", "red");
GV_AddEdge(test, et);
GV_AddAttr(et, "taillabel", "tailtest");
GV_GetNodes(test);
GV_AddEdge(test, a0, a1);
GV_AddEdge(test, a0, a2);
GV_AddEdge(test, a2, a5);
GV_AddEdge(test, a2, a3);
GV_AddEdge(test, a3, a4);
GV_AddAttr(a0, "color", "blue");
GV_AddAttr(test, "label", "Invisible");
GV_AddAttr(test, "label", "Test Graph :)");
GV_RemoveEdge(test, "a3", "a4");
GV_ClearAttr(a0, "color");
GV_AddNodeAttr(test, "color", "pink");
GV_AddEdgeAttr(test, "color", "green");

sg := GV_MakeGraph("Subgraph");
GV_AddAttr(sg, "color", "red");
GV_AddAttr(sg, "style", "filled");
GV_AddEdge(sg, GV_MakeNode("HELLO"), GV_MakeNode("WORLD"));
GV_AddSubgraph(test, sg);

GV_AddEdge(test, a3, a5);
Print(GV_ToDot(test));