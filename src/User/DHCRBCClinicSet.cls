Class User.DHCRBCClinicSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DPCS_RowID, SqlTableName = DHCRBC_ClinicSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DPCS_Loc_DR
Property DPCSLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DPCS_Loc_DR ];

/// DPCS_ReportFullFile
Property DPCSReportFullFile As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DPCS_ReportFullFile ];

/// DPCS_RhasReg
Property DPCSRhasReg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = DPCS_RhasReg ];

/// DPCS_RRegParam
Property DPCSRRegParam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DPCS_RRegParam ];

/// DPCS_RhasStudyNo
Property DPCSRhasStudyNo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = DPCS_RhasStudyNo ];

/// DPCS_RStuyParam
Property DPCSRStuyParam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DPCS_RStuyParam ];

/// DPCS_RDelim
Property DPCSRDelim As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = DPCS_RDelim ];

/// DPCS_ImageFullFile
Property DPCSImageFullFile As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = DPCS_ImageFullFile ];

/// DPCS_IhasReg
Property DPCSIhasReg As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DPCS_IhasReg ];

/// DPCS_IRegParam
Property DPCSIRegParam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = DPCS_IRegParam ];

/// DPCS_IhasStudyNo
Property DPCSIhasStudyNo As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = DPCS_IhasStudyNo ];

/// DPCS_IStudyNoParam
Property DPCSIStudyNoParam As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = DPCS_IStudyNoParam ];

/// DPCS_IDelim
Property DPCSIDelim As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = DPCS_IDelim ];

/// DPCS_RhasOther
Property DPCSRhasOther As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = DPCS_RhasOther ];

/// DPCS_ROtherParam
Property DPCSROtherParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DPCS_ROtherParam ];

/// DPCS_IhasOther
Property DPCSIhasOther As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = DPCS_IhasOther ];

/// DPCS_IOtherParam
Property DPCSIOtherParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DPCS_IOtherParam ];

/// DPCS_ROeordParam
Property DPCSRhasOeord As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 19, SqlFieldName = DPCS_RhasOeord ];

/// DPCS_ROeordParam
Property DPCSROeordParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = DPCS_ROeordParam ];

/// DPCS_IhasOeord
Property DPCSIhasOeord As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 21, SqlFieldName = DPCS_IhasOeord ];

/// DPCS_IOeordParam
Property DPCSIOeordParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = DPCS_IOeordParam ];

/// DPCS_IsOpenList
Property DPCSIsOpenList As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 23, SqlFieldName = DPCS_IsOpenList ];

/// 是否需要检验报告ID：DPCS_RhasRepId
Property DPCSRhasRepId As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 24, SqlFieldName = DPCS_RhasRepId ];

/// 报告ID参数名字  DPCS_RRepIdParam
Property DPCSRRepIdParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = DPCS_RRepIdParam ];

/// 是否需要检验报告ID：DPCS_IhasRepId
Property DPCSIhasRepId As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 26, SqlFieldName = DPCS_IhasRepId ];

/// 报告ID参数名字  DPCS_IRepIdParam
Property DPCSIRepIdParam As %Library.String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = DPCS_IRepIdParam ];

/// 报告开始日期
Property DPCSSRtartDate As %Library.Date [ SqlColumnNumber = 28, SqlFieldName = DPCS_RStartDate ];

/// 报告结束日期
Property DPCSREndDate As %Library.Date [ SqlColumnNumber = 29, SqlFieldName = DPCS_REndDate ];

/// 报告开始日期
Property DPCSSItartDate As %Library.Date [ SqlColumnNumber = 30, SqlFieldName = DPCS_IStartDate ];

/// 报告结束日期
Property DPCSIEndDate As %Library.Date [ SqlColumnNumber = 31, SqlFieldName = DPCS_IEndDate ];

/// 打开方式
Property DPCSROpenMethod As %Library.String [ SqlColumnNumber = 32, SqlFieldName = DPCS_ROpenMethod ];

/// 打开方式
Property DPCSIOpenMethod As %Library.String [ SqlColumnNumber = 33, SqlFieldName = DPCS_IOpenMethod ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBC("ClinicSet"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DPCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocClinicSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPCS_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DPCS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDatamap">
<Data name="DPCS_IDelim">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DPCS_IEndDate">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="DPCS_IOeordParam">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="DPCS_IOpenMethod">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="DPCS_IOtherParam">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DPCS_IRegParam">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DPCS_IRepIdParam">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="DPCS_IStartDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="DPCS_IStudyNoParam">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DPCS_IhasOeord">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="DPCS_IhasOther">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="DPCS_IhasReg">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DPCS_IhasRepId">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="DPCS_IhasStudyNo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DPCS_ImageFullFile">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DPCS_IsOpenList">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="DPCS_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DPCS_RDelim">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DPCS_REndDate">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="DPCS_ROeordParam">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="DPCS_ROpenMethod">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="DPCS_ROtherParam">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DPCS_RRegParam">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DPCS_RRepIdParam">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="DPCS_RStartDate">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="DPCS_RStuyParam">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DPCS_ReportFullFile">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DPCS_RhasOeord">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="DPCS_RhasOther">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DPCS_RhasReg">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DPCS_RhasRepId">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DPCS_RhasStudyNo">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^DHCRBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DPCS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ClinicSet"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DPCS_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCClinicSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
