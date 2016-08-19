// Generated at Thu Jun 09 10:28:06 CEST 2016 from platform:/resource/org.occiware.clouddesigner.occi.linkeddata/model/linkeddata.occie by org.occiware.clouddesigner.occi.gen.alloy

// ======================================================================
//
// Static Semantics for OCCI Extension 'linkeddata'
//
// ======================================================================

module linkeddata

open util/boolean
open OCCI

// ======================================================================
//
// Imported extensions
//
// ======================================================================

open core
open infrastructure
open platform

// ======================================================================
//
// OCCI extension 'linkeddata'
//
// ======================================================================

one sig extension extends Extension {} {
    name = "linkeddata"
    scheme = "http://occiware.org/linkeddata#"
    import = core/extension + infrastructure/extension + platform/extension
    kinds = ldproject + lddatabaselink + ldprojectlink
    no mixins
    no types
}

// ======================================================================
//
// OCCI kind 'http://occiware.org/linkeddata#ldproject'
//
// ======================================================================

one sig ldproject extends Kind {} {
    term = "ldproject"
    scheme = "http://occiware.org/linkeddata#"
    title = "LDProject"
    parent = core/resource
    attributes = ldproject_occi_ld_project_name + ldproject_occi_ld_project_published + ldproject_occi_ld_project_robust
    actions = ldproject_publish + ldproject_unpublish + ldproject_update
    entities in Ldproject
}

//
// OCCI attribute 'occi.ld.project.name'
//
one sig ldproject_occi_ld_project_name extends Attribute {} {
    name = "occi.ld.project.name"
    type = core/String_DataType
    mutable = True
    required = True
    no default
    no description
    multiple_values = False
}

//
// OCCI attribute 'occi.ld.project.published'
//
one sig ldproject_occi_ld_project_published extends Attribute {} {
    name = "occi.ld.project.published"
    type = core/Boolean_DataType
    mutable = True
    required = False
    default = "false"
    no description
    multiple_values = False
}

//
// OCCI attribute 'occi.ld.project.robust'
//
one sig ldproject_occi_ld_project_robust extends Attribute {} {
    name = "occi.ld.project.robust"
    type = core/Boolean_DataType
    mutable = True
    required = False
    default = "true"
    no description
    multiple_values = False
}

//
// OCCI action 'http://occiware.org/linkeddata/ldproject/action#publish'
//
one sig ldproject_publish extends Action {} {
    term = "publish"
    scheme = "http://occiware.org/linkeddata/ldproject/action#"
    no title
    no attributes
}


//
// OCCI action 'http://occiware.org/linkeddata/ldproject/action#unpublish'
//
one sig ldproject_unpublish extends Action {} {
    term = "unpublish"
    scheme = "http://occiware.org/linkeddata/ldproject/action#"
    no title
    no attributes
}


//
// OCCI action 'http://occiware.org/linkeddata/ldproject/action#update'
//
one sig ldproject_update extends Action {} {
    term = "update"
    scheme = "http://occiware.org/linkeddata/ldproject/action#"
    no title
    no attributes
}


// ======================================================================
// Signature for Ldproject
// ======================================================================

sig Ldproject extends core/Resource {
    occi_ld_project_name : one String,
    occi_ld_project_published : lone core/Boolean,
    occi_ld_project_robust : lone core/Boolean,
} {
    hasKind[ldproject]
}

// ======================================================================
//
// OCCI kind 'http://occiware.org/linkeddata#lddatabaselink'
//
// ======================================================================

one sig lddatabaselink extends Kind {} {
    term = "lddatabaselink"
    scheme = "http://occiware.org/linkeddata#"
    title = "LDDatabaseLink"
    parent = core/link
    attributes = lddatabaselink_occi_ld_dblink_database + lddatabaselink_occi_ld_dblink_port
    no actions
    entities in Lddatabaselink
}

//
// OCCI attribute 'occi.ld.dblink.database'
//
one sig lddatabaselink_occi_ld_dblink_database extends Attribute {} {
    name = "occi.ld.dblink.database"
    type = core/String_DataType
    mutable = True
    required = True
    default = "datacore"
    no description
    multiple_values = False
}

//
// OCCI attribute 'occi.ld.dblink.port'
//
one sig lddatabaselink_occi_ld_dblink_port extends Attribute {} {
    name = "occi.ld.dblink.port"
    type = core/Number_DataType
    mutable = True
    required = False
    default = "27017"
    no description
    multiple_values = False
}

// ======================================================================
// Signature for Lddatabaselink
// ======================================================================

sig Lddatabaselink extends core/Link {
    occi_ld_dblink_database : one String,
    occi_ld_dblink_port : lone core/Number,
} {
    hasKind[lddatabaselink]
}

// ======================================================================
//
// OCCI kind 'http://occiware.org/linkeddata#ldprojectlink'
//
// ======================================================================

one sig ldprojectlink extends Kind {} {
    term = "ldprojectlink"
    scheme = "http://occiware.org/linkeddata#"
    no title
    parent = core/link
    no attributes
    no actions
    entities in Ldprojectlink
}

// ======================================================================
// Signature for Ldprojectlink
// ======================================================================

sig Ldprojectlink extends core/Link {
} {
    hasKind[ldprojectlink]
}

// ======================================================================
// Check consistency, i.e., there is at least one instance of this model.
// ======================================================================

run Consistency {} for 10

// ======================================================================
// Instance containing the OCCI Type System only.
// ======================================================================

run The_OCCI_Type_System {} for 0

