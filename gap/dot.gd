#############################################################################
##
##  dot.gd
##  Copyright (C) 2024                                      Matthew Pancer
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

#! @Chapter
#! @ChapterTitle Getting started
#! This chapter very briefly explains what &DOT; and &Graphviz; are, provides
#! some key basic concepts relating to them, and how this package interacts
#! with them.

#! @Section A brief introduction
#! &DOT; is a language for descrbing to a computer how to display a visualization
#! of a graph or digraph. &Graphviz; is a graph visualization software which can
#! consume &DOT; and produce visual outputs. This package is designed to allow
#! users to programmatically construct objects in &GAP; which can then be
#! converted into &DOT;. That &DOT; can then be input to the &Graphviz; software
#! to produce a visual output. As &DOT; is central to the design of this package
#! it will likely be helpful to have a basic understanding of the language.
#! For more information about &DOT; see
#! <URL>https://graphviz.org/doc/info/lang.html</URL>.
#! <P/>
#!
#! The &GAPGraphviz; package for &GAP; is intended to facilitate the creation
#! and rendering of graph descriptions in the &DOT; language of the &Graphviz;
#! graph drawing software.
#! <P/>
#!
#! You can create a &GAPGraphviz; object, assemble the graph by adding nodes
#! and edges, setting attributes, labels and so on, and retrieve its &DOT;
#! source code string. You can save the source code
#! to a file (using <Ref Func="FileString" BookName="ref"/>) and render it
#! with the &Graphviz; installation of your system; or you can
#! use the <Ref Func="Splash"/> function to directly inspect the resulting
#! graph (depending on your system and the software installed).

#! @Section What this package is not
#!
#! This package does not implement a parser of the &DOT; language and does only
#! minimal checks when assembling a graph. In particular, if you set attributes
#! which don't exist in &DOT;, then the resulting string might not be valid,
#! and might not render correctly using &Graphviz;.

#! @Section A first example
#! Here's an example of how to use the &GAPGraphviz; package, to construct a
#! &DOT; representation of a finite state automata. This example is taken from
#! <URL>https://graphviz.readthedocs.io/en/stable/examples.html</URL> or
#! <URL>https://graphviz.org/Gallery/directed/fsm.html</URL>.
#!
#! @BeginExampleSession
#! gap> LoadPackage("graphviz");;
#! gap> f := GraphvizDigraph("finite_state_machine");
#! <graphviz digraph "finite_state_machine" with 0 nodes and 0 edges>
#! gap> GraphvizSetAttr(f, "rankdir=LR");
#! <graphviz digraph "finite_state_machine" with 0 nodes and 0 edges>
#! gap> GraphvizSetAttr(f, "size=\"8,5\"");
#! <graphviz digraph "finite_state_machine" with 0 nodes and 0 edges>
#! gap> terminals := GraphvizAddContext(f, "terminals");
#! <graphviz context "terminals" with 0 nodes and 0 edges>
#! gap> GraphvizSetAttr(terminals, "node [shape=doublecircle]");
#! <graphviz context "terminals" with 0 nodes and 0 edges>
#! gap> GraphvizAddNode(terminals, "LR_0");
#! <graphviz node "LR_0">
#! gap> GraphvizAddNode(terminals, "LR_3");
#! <graphviz node "LR_3">
#! gap> GraphvizAddNode(terminals, "LR_4");
#! <graphviz node "LR_4">
#! gap> GraphvizAddNode(terminals, "LR_8");
#! <graphviz node "LR_8">
#! gap> nodes := GraphvizAddContext(f, "nodes");
#! <graphviz context "nodes" with 0 nodes and 0 edges>
#! gap> GraphvizSetAttr(nodes, "node [shape=circle]");
#! <graphviz context "nodes" with 0 nodes and 0 edges>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_0", "LR_2"),
#! > "label", "\"SS(B)\"");
#! <graphviz edge (LR_0, LR_2)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_0", "LR_1"),
#! > "label", "\"SS(S)\"");
#! <graphviz edge (LR_0, LR_1)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_1", "LR_3"),
#! "label", "\"S($end)\"");
#! <graphviz edge (LR_1, LR_3)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_2", "LR_6"),
#! > "label", "\"SS(b)\"");
#! <graphviz edge (LR_2, LR_6)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_2", "LR_5"),
#! > "label", "\"SS(a)\"");
#! <graphviz edge (LR_2, LR_5)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_2", "LR_4"),
#! > "label", "\"S(A)\"");
#! <graphviz edge (LR_2, LR_4)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_5", "LR_7"),
#! > "label", "\"S(b)\"");
#! <graphviz edge (LR_5, LR_7)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_5", "LR_5"),
#! > "label", "\"S(a)\"");
#! <graphviz edge (LR_5, LR_5)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_6", "LR_6"),
#! > "label", "\"S(b)\"");
#! <graphviz edge (LR_6, LR_6)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_6", "LR_5"),
#! > "label", "\"S(a)\"");
#! <graphviz edge (LR_6, LR_5)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_7", "LR_8"),
#! > "label", "\"S(b)\"");
#! <graphviz edge (LR_7, LR_8)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_7", "LR_5"),
#! > "label", "\"S(a)\"");
#! <graphviz edge (LR_7, LR_5)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_8", "LR_6"),
#! > "label", "\"S(b)\"");
#! <graphviz edge (LR_8, LR_6)>
#! gap> GraphvizSetAttr(GraphvizAddEdge(nodes, "LR_8", "LR_5"),
#! > "label", "\"S(a)\"");
#! <graphviz edge (LR_8, LR_5)>
#! gap> Print(AsString(f), "\n");
#! //dot
#! digraph finite_state_machine {
#!     rankdir=LR size="8,5"
#! // terminals context
#!     node [shape=doublecircle]
#!     LR_0
#!     LR_3
#!     LR_4
#!     LR_8
#!     rankdir=LR size="8,5"
#!
#! // nodes context
#!     node [shape=circle]
#!     LR_2
#!     LR_0 -> LR_2 [label="SS(B)"]
#!     LR_1
#!     LR_0 -> LR_1 [label="SS(S)"]
#!     LR_1 -> LR_3 [label="S($end)"]
#!     LR_6
#!     LR_2 -> LR_6 [label="SS(b)"]
#!     LR_5
#!     LR_2 -> LR_5 [label="SS(a)"]
#!     LR_2 -> LR_4 [label="S(A)"]
#!     LR_7
#!     LR_5 -> LR_7 [label="S(b)"]
#!     LR_5 -> LR_5 [label="S(a)"]
#!     LR_6 -> LR_6 [label="S(b)"]
#!     LR_6 -> LR_5 [label="S(a)"]
#!     LR_7 -> LR_8 [label="S(b)"]
#!     LR_7 -> LR_5 [label="S(a)"]
#!     LR_8 -> LR_6 [label="S(b)"]
#!     LR_8 -> LR_5 [label="S(a)"]
#!     rankdir=LR size="8,5"
#!
#! }
#! gap> Splash(f);
#! @EndExampleSession
#!
#! Provided that you have &Graphviz; installed on your computer, the last line
#! of the example <C>Splash(f)</C> will produce the following picture:
#!
#! <Alt Only="HTML">
#!     <![CDATA[
#!     <figure>
#!         <img height="400" src="png/finite_state_machine.png"/>
#!     </figure>
#!     ]]>
#! </Alt>
#!
#! There are lots more examples in the <F>examples</F> directory within the
#! &Graphviz; package for &GAP; directory.

#! @Chapter Full Reference
#! This chapter contains all of the gory details about the functionality of the
#! &GAPGraphviz; package for &GAP;.

#! @Section Graphviz Categories
#! Blurg

#! @BeginGroup Filters
#! @Description Every object in graphviz belongs to the IsGraphvizObject
#! category. The categories following it are for further specificity on the
#! type of objects. These are graphs, digraphs, nodes and edges respectively.
#! All are direct subcategories of IsGraphvizObject excluding IsGraphvizDigraph
#! which is a subcategory of is IsGraphvizGraph.

#! TODO
DeclareCategory("IsGraphvizObject", IsObject);

#! TODO
DeclareCategory("IsGraphvizGraphDigraphOrContext", IsGraphvizObject);
#! TODO
DeclareCategory("IsGraphvizGraph", IsGraphvizGraphDigraphOrContext);
#! TODO
DeclareCategory("IsGraphvizDigraph", IsGraphvizGraphDigraphOrContext);
#! TODO
DeclareCategory("IsGraphvizContext", IsGraphvizGraphDigraphOrContext);

#! TODO
DeclareCategory("IsGraphvizNodeOrEdge", IsGraphvizObject);
#! TODO
DeclareCategory("IsGraphvizNode", IsGraphvizNodeOrEdge);
#! TODO
DeclareCategory("IsGraphvizEdge", IsGraphvizNodeOrEdge);

#! @EndGroup

#! @Section Constructors

#! @BeginGroup
#! @GroupTitle Constructors for Graphs
#! @Arguments name
#! @Returns a new graphviz graph
#! @Description Creates a new graphviz graph optionally with the provided name.
DeclareOperation("GraphvizGraph", [IsObject]);
DeclareOperation("GraphvizGraph", []);
#! @EndGroup

#! @BeginGroup
#! @GroupTitle Constructors for Digraphs
#! @Arguments name
#! @Returns a new graphviz digraph
#! @Description Creates a new graphviz digraph optionally with the provided name.
DeclareOperation("GraphvizDigraph", [IsObject]);
DeclareOperation("GraphvizDigraph", []);
#! @EndGroup

#! @Section Get Operations
#! This section covers the operations for getting information about graphviz
#! objects.

#! @Subsection For all graphviz objects.

#! @Arguments obj
#! @Returns the name of the provided graphviz object
#! @Description Gets the name of the provided graphviz object.
DeclareOperation("GraphvizName", [IsGraphvizObject]);

#! @Arguments obj
#! @Returns the attributes of the provided graphviz object
#! @Description Gets the attributes of the provided graphviz object.
DeclareOperation("GraphvizAttrs", [IsGraphvizObject]);

#! @Subsection For only graphs and digraphs.

#! @Arguments graph
#! @Returns the nodes of the provided graphviz graph.
#! @Description Gets the nodes of the provided graphviz graph.
# From https://graphviz.org/doc/info/lang.html
# An ID is one of the following:
# Any string of alphabetic ([a-zA-Z\200-\377]) characters, underscores ('_') or
# digits([0-9]), not beginning with a digit;
# a numeral [-]?(.[0-9]⁺ | [0-9]⁺(.[0-9]*)? );
# any double-quoted string ("...") possibly containing escaped quotes (\")¹;
# an HTML string (<...>).
# TODO specify
DeclareOperation("GraphvizNodes", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments graph
#! @Returns the subgraphs of the provided graphviz graph.
#! @Description gets the subgraphs of a provided graphviz graph.
DeclareOperation("GraphvizSubgraphs", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments graph
#! @Returns the contexts of the provided graphviz graph, digraph or context.
#! @Description gets the contexts of a provided graphviz graph, digraph
#! or context.
DeclareOperation("GraphvizContexts", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments graph, name
#! @Returns a graph with the provided name.
#! @Description
#! Searches through the tree of subgraphs connected to this subgraph for a graph
#! with the provided name.
#! It returns the graph if it exists.
#! If no such graph exists then it will return <K>fail</K>.
DeclareOperation("GraphvizFindSubgraphRecursive",
[IsGraphvizGraphDigraphOrContext, IsObject]);

#! @Arguments graph
#! @Returns the edges of the provided graphviz graph.
#! @Description Gets the edges of the provided graphviz graph.
DeclareOperation("GraphvizEdges", [IsGraphvizGraphDigraphOrContext]);
DeclareOperation("GraphvizEdges",
[IsGraphvizGraphDigraphOrContext, IsObject, IsObject]);

#! @Subsection For only edges.

#! @Arguments edge
#! @Returns the head of the provided graphviz edge.
#! @Description Gets the head of the provided graphviz graph.
DeclareOperation("GraphvizHead", [IsGraphvizEdge]);

#! @Arguments edge
#! @Returns the head of the provided graphviz tail.
#! @Description Gets the tail of the provided graphviz graph.
DeclareOperation("GraphvizTail", [IsGraphvizEdge]);

#! @Section Set Operations
#! This section covers operations for modifying graphviz objects.

#! @Subsection For modifying graphs.

#! @Arguments graph, name
#! @Returns the modified graph.
#! @Description Sets the name of a graphviz graph or digraph.
DeclareOperation("GraphvizSetName", [IsGraphvizGraphDigraphOrContext, IsObject]);

#! @Arguments graph, node
#! @Returns the modified graph.
#! @Description Adds a node to the graph.
#! If a node with the same name is already present the operation fails.
DeclareOperation("GraphvizAddNode", [IsGraphvizGraphDigraphOrContext, IsObject]);

#! @Arguments graph, edge
#! @Returns the modified graph.
#! @Description Adds an edge to the graph.
#! If no nodes with the same name are in the graph then the edge's nodes will be
#! added to the graph. If different nodes with the same name are in the graph
#! then the operation fails.
#! TODO I dont believe this is accurate - think it will connect existing ones
#! underlying private function would fail though - TODO double check.
DeclareOperation("GraphvizAddEdge",
[IsGraphvizGraphDigraphOrContext, IsObject, IsObject]);

#! @Arguments graph, filter, name
#! @Returns the new subgraph.
#! @Description Adds a subgraph to a graph.
DeclareOperation("GraphvizAddSubgraph",
[IsGraphvizGraphDigraphOrContext, IsObject]);
DeclareOperation("GraphvizAddSubgraph", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments graph, filter, name
#! @Returns the new context.
#! @Description Adds a context to a graph.
DeclareOperation("GraphvizAddContext",
[IsGraphvizGraphDigraphOrContext, IsObject]);
DeclareOperation("GraphvizAddContext", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments graph, node
#! @Returns the modified graph.
#! @Description Removes the node from the graph.
DeclareOperation("GraphvizRemoveNode",
[IsGraphvizGraphDigraphOrContext, IsObject]);

#! @Arguments graph, predicate
#! @Returns the modified graph.
#! @Description Filters the graph's edges using the provided predicate.
DeclareOperation("GraphvizFilterEdges",
[IsGraphvizGraphDigraphOrContext, IsFunction]);

#! @Arguments graph, head_name, tail_name
#! @Returns the modified graph.
#! @Description Filters the graph's edges, removing edges between nodes with
#! the specified names.
DeclareOperation("GraphvizRemoveEdges",
[IsGraphvizGraphDigraphOrContext, IsObject, IsObject]);

#! @Subsection For modifying object attributes.

#! @Arguments obj, attrs
#! @Returns the modified object.
#! @Description
#!    Updates the attributes of the object.
#!    All current attributes remain.
#!    If an attribute already exists and a new value is provided, the old value
#!    will be overwritten.
DeclareOperation("GraphvizSetAttrs", [IsGraphvizObject, IsRecord]);
DeclareOperation("GraphvizSetAttr", [IsGraphvizObject, IsObject, IsObject]);
DeclareOperation("GraphvizSetAttr", [IsGraphvizObject, IsObject]);

#! @Arguments obj, attr
#! @Returns the modified object.
#! @Description Removes an attribute from the object provided.
DeclareOperation("GraphvizRemoveAttr", [IsGraphvizObject, IsObject]);

#! @Section Outputting
#! @Arguments graph
#! @Returns the dot representation of the graphviz object.
DeclareOperation("AsString", [IsGraphvizGraphDigraphOrContext]);

#! @Arguments obj
#! @Returns the graphviz representation of the object.
#! @Description
#!  Unimplemented operation which depending packages can implement.
#!  Should output the graphviz package representation of the object.
DeclareOperation("Graphviz", [IsObject]);

DeclareOperation("GraphvizSetNodeColors",
[IsGraphvizGraphDigraphOrContext, IsList]);
DeclareOperation("GraphvizSetNodeLabels",
[IsGraphvizGraphDigraphOrContext, IsList]);

DeclareGlobalFunction("ErrorIfNotValidColor");

# TODO doc
DeclareOperation("\[\]", [IsGraphvizNode, IsObject]);
# TODO doc
DeclareOperation("\[\]\:\=", [IsGraphvizNode, IsObject, IsObject]);

# TODO doc
DeclareOperation("\[\]", [IsGraphvizEdge, IsObject]);
# TODO doc
DeclareOperation("\[\]\:\=", [IsGraphvizEdge, IsObject, IsObject]);

# TODO doc
DeclareOperation("\[\]", [IsGraphvizGraphDigraphOrContext, IsObject]);
