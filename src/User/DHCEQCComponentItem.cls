Class User.DHCEQCComponentItem Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = CI_RowID, SqlTableName = DHC_EQCComponentItem, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// CI_ComponentDR
Property CIComponentDR As User.DHCEQCComponent [ SqlColumnNumber = 2, SqlFieldName = CI_ComponentDR ];

/// CI_Name
Property CIName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CI_Name ];

/// CI_Caption
Property CICaption As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CI_Caption ];

/// CI_CaptionStyle
Property CICaptionStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CI_CaptionStyle ];

/// CI_ClassMethod
Property CIClassMethod As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CI_ClassMethod ];

/// CI_ClassMethodIfDirty
Property CIClassMethodIfDirty As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CI_ClassMethodIfDirty ];

/// CI_CUstomExpression
Property CICustomExpression As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CI_CustomExpression ];

/// CI_DataType
Property CIDataType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CI_DataType ];

/// CI_DefaultValueAlways
Property CIDefaultValueAlways As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CI_DefaultValueAlways ];

/// CI_DefaultValueExpression
Property CIDefaultValueExpression As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CI_DefaultValueExpression ];

/// CI_Description
Property CIDescription As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CI_Description ];

/// CI_Disabled
Property CIDisabled As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = CI_Disabled ];

/// CI_DisplayOnly
Property CIDisplayOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = CI_DisplayOnly ];

/// CI_DisplayType
Property CIDisplayType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CI_DisplayType ];

/// CI_HelpUrl
Property CIHelpUrl As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CI_HelpUrl ];

/// CI_Hidden
Property CIHidden As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = CI_Hidden ];

/// CI_Image
Property CIImage As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CI_Image ];

/// CI_LinkComponent
Property CILinkComponent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CI_LinkComponent ];

/// CI_LinkConditionalExp
Property CILinkConditionalExp As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = CI_LinkConditionalExp ];

/// CI_LinkExpression
Property CILinkExpression As %Library.String(COLLATION = "Exact", MAXLEN = 500, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = CI_LinkExpression ];

/// CI_LinkUrl
Property CILinkUrl As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = CI_LinkUrl ];

/// CI_LinkWorkFlow
Property CILinkWorkFlow As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = CI_LinkWorkFlow ];

/// CI_ListCellStyle
Property CIListCellStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = CI_ListCellStyle ];

/// CI_LookupBrokerMethod
Property CILookupBrokerMethod As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = CI_LookupBrokerMethod ];

/// CI_LookupClassName
Property CILookupClassName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = CI_LookupClassName ];

/// CI_LookupCustomComponent
Property CILookupCustomComponent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = CI_LookupCustomComponent ];

/// CI_LookupJavascriptFunction
Property CILookupJavascriptFunction As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = CI_LookupJavascriptFunction ];

/// CI_LookupProperties
Property CILookupProperties As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = CI_LookupProperties ];

/// CI_LookupQueryName
Property CILookupQueryName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = CI_LookupQueryName ];

/// CI_LookupUserDefined
Property CILookupUserDefined As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = CI_LookupUserDefined ];

/// CI_LookupUserDefinedValues
Property CILookupUserDefinedValues As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = CI_LookupUserDefinedValues ];

/// CI_NestedComponent
Property CINestedComponent As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = CI_NestedComponent ];

/// CI_NestedCondExpr
Property CINestedCondExpr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = CI_NestedCondExpr ];

/// CI_OrderMode
Property CIOrderMode As %Library.String(DISPLAYLIST = ",可排序,升序,降序", MAXLEN = 4, SELECTIVITY = "25.0000%", VALUELIST = ",1,2,3") [ SqlColumnNumber = 35, SqlFieldName = CI_OrderMode ];

/// CI_Password
Property CIPassword As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = CI_Password ];

/// CI_ReadOnly
Property CIReadOnly As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 37, SqlFieldName = CI_ReadOnly ];

/// CI_ReferencedObject
Property CIReferencedObject As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = CI_ReferencedObject ];

/// CI_Required
Property CIRequired As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 39, SqlFieldName = CI_Required ];

/// CI_ShortcutKey
Property CIShortcutKey As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = CI_ShortcutKey ];

/// CI_ShowInNewWindow
Property CIShowInNewWindow As %Library.String(COLLATION = "Exact", MAXLEN = 90, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = CI_ShowInNewWindow ];

/// CI_Style
Property CIStyle As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = CI_Style ];

/// CI_TabSequence
Property CITabSequence As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = CI_TabSequence ];

/// CI_Tooltip
Property CITooltip As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = CI_Tooltip ];

/// CI_ValueGet
Property CIValueGet As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = CI_ValueGet ];

/// CI_ValueSet
Property CIValueSet As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = CI_ValueSet ];

/// CI_Frozen
Property CIFrozen As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 47, SqlFieldName = CI_Frozen ];

/// CI_TableName
Property CITableName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = CI_TableName ];

/// CI_ItemType
Property CIItemType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = CI_ItemType ];

/// CI_MultiFlag
Property CIMultiFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = CI_MultiFlag ];

/// CI_hold1
Property CIhold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = CI_hold1 ];

/// CI_hold2
Property CIhold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = CI_hold2 ];

/// CI_hold3
Property CIhold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = CI_hold3 ];

/// CI_hold4
Property CIhold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = CI_hold4 ];

/// CI_hold5
Property CIhold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = CI_hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCComponentItem",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CI_Caption">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CI_CaptionStyle">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CI_ClassMethod">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CI_ClassMethodIfDirty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CI_ComponentDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CI_CustomExpression">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CI_DataType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CI_DefaultValueAlways">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CI_DefaultValueExpression">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CI_Description">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CI_Disabled">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CI_DisplayOnly">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="CI_DisplayType">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="CI_Frozen">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="CI_HelpUrl">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="CI_Hidden">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="CI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="CI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="CI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="CI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="CI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="CI_Image">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="CI_ItemType">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="CI_LinkComponent">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="CI_LinkConditionalExp">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="CI_LinkExpression">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="CI_LinkUrl">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="CI_LinkWorkFlow">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="CI_ListCellStyle">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="CI_LookupBrokerMethod">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="CI_LookupClassName">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="CI_LookupCustomComponent">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="CI_LookupJavascriptFunction">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="CI_LookupProperties">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="CI_LookupQueryName">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="CI_LookupUserDefined">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="CI_LookupUserDefinedValues">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="CI_MultiFlag">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="CI_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CI_NestedComponent">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="CI_NestedCondExpr">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="CI_OrderMode">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="CI_Password">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="CI_ReadOnly">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="CI_ReferencedObject">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="CI_Required">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="CI_ShortcutKey">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="CI_ShowInNewWindow">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="CI_Style">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="CI_TabSequence">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="CI_TableName">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="CI_Tooltip">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="CI_ValueGet">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="CI_ValueSet">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCComponentItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>{CI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexComponent">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>"DHCEQCComponentItem"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>"Component"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{CI_ComponentDR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>Sub</AccessType>
<Expression>{CI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCComponentItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
