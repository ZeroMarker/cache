Class User.INSUTarContrast Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INTCT_Rowid, SqlTableName = INSU_TarContrast, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INTCT_His_Dr
Property INTCTHisDr As User.DHCTarItem(CAPTION = "HIS收费项目ID") [ SqlColumnNumber = 2, SqlFieldName = INTCT_His_Dr ];

/// INTCT_HisCode
Property INTCTHisCode As %Library.String(CAPTION = "HIS收费项目代码", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INTCT_HisCode ];

/// INTCT_HisDesc
Property INTCTHisDesc As %Library.String(CAPTION = "HIS收费项目描述", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INTCT_HisDesc ];

/// INTCT_Insu_Dr
Property INTCTInsuDr As User.INSUTarItems(CAPTION = "医保目录ID") [ SqlColumnNumber = 5, SqlFieldName = INTCT_Insu_Dr ];

/// INTCT_InsuCode
Property INTCTInsuCode As %Library.String(CAPTION = "医保目录编码", COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INTCT_InsuCode ];

/// INTCT_InsuDesc
Property INTCTInsuDesc As %Library.String(CAPTION = "医保目录描述", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INTCT_InsuDesc ];

/// INTCT_Class
Property INTCTClass As %Library.String(CAPTION = "医保项目类别", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INTCT_Class ];

/// INTCT_Level
Property INTCTLevel As %Library.String(CAPTION = "项目等级", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INTCT_Level ];

/// INTCT_PatType
Property INTCTPatTypeDr As %Library.String(CAPTION = "人员类别", COLLATION = "Exact", MAXLEN = 19, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INTCT_PatType_Dr ];

/// INTCT_Amount
Property INTCTAmount As %Library.Float(CAPTION = "数量") [ SqlColumnNumber = 11, SqlFieldName = INTCT_Amount ];

/// INTCT_DrAddFlag
Property INTCTDrAddFlag As %Library.String(CAPTION = "对照审核标志", COLLATION = "Exact", MAXLEN = 1, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INTCT_DrAddFlag ];

/// INTCT_ActiveDate
Property INTCTActiveDate As %Library.Date(CAPTION = "对照生效日期", FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = INTCT_ActiveDate ];

/// INTCT_ZText
Property INTCTZText As %Library.String(CAPTION = "INTCTZText", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INTCT_ZText ];

/// INTCT_DicType
Property INTCTDicType As %Library.String(CAPTION = "医保类型", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INTCT_DicType ];

/// INTCT_User_Dr
Property INTCTUserDr As User.SSUser(CAPTION = "添加人") [ SqlColumnNumber = 16, SqlFieldName = INTCT_User_Dr ];

/// INTCT_Date
Property INTCTDate As %Library.Date(CAPTION = "添加日期", FORMAT = 1) [ SqlColumnNumber = 17, SqlFieldName = INTCT_Date ];

/// INTCT_Time
Property INTCTTime As %Library.Time(CAPTION = "添加时间") [ SqlColumnNumber = 18, SqlFieldName = INTCT_Time ];

/// INTCT_ADDIP
Property INTCTADDIP As %Library.String(CAPTION = "添加地址", COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = INTCT_ADDIP ];

/// INTCT_Unique
Property INTCTUnique As %Library.String(CAPTION = "医保中心唯一码", COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = INTCT_Unique ];

/// INTCT_ExpiryDate
Property INTCTExpiryDate As %Library.Date(CAPTION = "对照失效日期", FORMAT = 1) [ SqlColumnNumber = 21, SqlFieldName = INTCT_ExpiryDate ];

/// INTCT_UpLoadDate
Property INTCTUpLoadDate As %Library.Date(CAPTION = "上传日期", FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = INTCT_UpLoadDate ];

/// INTCT_UpLoadTime
Property INTCTUpLoadTime As %Library.Time(CAPTION = "上传时间", FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = INTCT_UpLoadTime ];

/// INTCT_DownLoadDate
Property INTCTDownLoadDate As %Library.Date(CAPTION = "下载日期", FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = INTCT_DownLoadDate ];

/// INTCT_DownLoadTime
Property INTCTDownLoadTime As %Library.Time(CAPTION = "下载时间", FORMAT = 1) [ SqlColumnNumber = 25, SqlFieldName = INTCT_DownLoadTime ];

/// INTCT_LastModDate
Property INTCTLastModDate As %Library.Date(CAPTION = "上次修改日期", FORMAT = 1) [ SqlColumnNumber = 26, SqlFieldName = INTCT_LastModDate ];

/// INTCT_LastModTime
Property INTCTLastModTime As %Library.Time(CAPTION = "上次修改时间", FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = INTCT_LastModTime ];

/// INTCT_HospDr
Property INTCTHospDr As %Library.String(CAPTION = "院区") [ SqlColumnNumber = 28, SqlFieldName = INTCT_HospDr ];

/// INTCT_HospDr 
Property INTCTAuditUser As %Library.String(CAPTION = "院内审核人") [ SqlColumnNumber = 29, SqlFieldName = INTCT_AuditUser ];

/// INTCT_HospDr 
Property INTCTAuditDate As %Library.Date(CAPTION = "院内审核日期", FORMAT = 1) [ SqlColumnNumber = 30, SqlFieldName = INTCT_AuditDate ];

/// INTCT_HospDr 
Property INTCTAuditTime As %Library.Time(CAPTION = "院内审核时间", FORMAT = 1) [ SqlColumnNumber = 31, SqlFieldName = INTCT_AuditTime ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINTCT)</SqlIdExpression>
<SQLMap name="DATAMasterMap">
<Data name="INTCT_ADDIP">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="INTCT_ActiveDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INTCT_Amount">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTCT_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="INTCT_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="INTCT_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="INTCT_Class">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTCT_Date">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INTCT_DicType">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INTCT_DownLoadDate">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="INTCT_DownLoadTime">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="INTCT_DrAddFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTCT_ExpiryDate">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="INTCT_HisCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTCT_HisDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTCT_His_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTCT_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="INTCT_InsuCode">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INTCT_InsuDesc">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTCT_Insu_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTCT_LastModDate">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="INTCT_LastModTime">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="INTCT_Level">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTCT_PatType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTCT_Time">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="INTCT_Unique">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="INTCT_UpLoadDate">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="INTCT_UpLoadTime">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="INTCT_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INTCT_ZText">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Global>^DHCINTCT</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexClass">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"CLASS"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTCT_Class}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexClassHosp">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"CLASS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTCT_Class}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisDr">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DHCTID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTCT_His_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHisDrHosp">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DHCTID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTCT_His_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuDr">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"INSUTID"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTCT_Insu_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexInsuDrHosp">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"INSUTID"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTCT_Insu_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLevel">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LEVEL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTCT_Level}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLevelHosp">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTCT_ADDIP</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LEVEL"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTCT_Level}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeDate">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Type_Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTCT_His_Dr}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTCT_DicType}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTCT_ActiveDate}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexofTypeDateHosp">
<Global>^DHCINTCT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L8}</Expression>
<Field>INTCT_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTCT_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Type_Date"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTCT_His_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTCT_DicType}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INTCT_ActiveDate}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{INTCT_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUTarContrastS</StreamLocation>
<Type>%Storage.SQL</Type>
}

// ------------------------------------------------------------------------------------------

/// 删除
Trigger BeforDelete [ Event = DELETE ]
{
  	s $zt="BeforDeleteError"
	s bdRowid=+{INTCT_Rowid}
	q:bdRowid<1
	q:$d(^DHCINTCT(bdRowid))=0
	s bdStr=^DHCINTCT(bdRowid)
	s classname=$classname()
	s ^CacheTemp(classname,"BeforDelete",$j,bdRowid)=bdStr
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)=userid
	q $$$OK
BeforDeleteError
	s $zt=""
	q $$$OK
}

Trigger AfterDelete [ Event = DELETE, Time = AFTER ]
{
  	s $zt="AfterDeleteError"
	s bdRowid=+{INTCT_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforDelete",$j,bdRowid))=0 $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	s TableTypeCode=$p(bdStr,"^",12)
	i $d(^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data) values(UCase(:classname),:bdRowid,:TableTypeCode,'DELETE',:optdate,:opttime,:userid,:bdStr))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	.k ^CacheTemp(classname,"BeforDeleteUSERID",$j,bdRowid)
	
	q $$$OK
AfterDeleteError
	s $zt=""
	q $$$OK
}

/// 更新
Trigger BeforeUpdate [ Event = UPDATE ]
{
	s $zt="BeforeUpdateError"
	;s ^TMPZMC("tttt u")=$classname() ;%session.Get("LOGON.USERID")	
	s bdRowid=+{INTCT_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTCT(bdRowid))=0 $$$OK
	s bdStr=^DHCINTCT(bdRowid)
	s ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)=userid
	q $$$OK
BeforeUpdateError
	s $zt=""
	q $$$OK
}

Trigger AfterUpdate [ Event = UPDATE, Time = AFTER ]
{
  	s $zt="AfterUpdate"
	s bdRowid=+{INTCT_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforeUpdate",$j,bdRowid))=0 $$$OK
	s updatestr=^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	q:(^DHCINTCT(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",12)
	s NewData=$g(^DHCINTCT(bdRowid))
	s TableTypeCode="2"
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'UPDATE',:optdate,:opttime,:userid,:bdStr,:NewData))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	.k ^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	q $$$OK
AfterUpdate
	s $zt=""
	q $$$OK
}

/// 修改(注意对象二次修改时会触发update)
Method %OnBeforeSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnBeforeSaveError"
	s bdRowid=+$this.%Id()
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTCT(bdRowid))=0 $$$OK
	s bdStr=^DHCINTCT(bdRowid)
	s ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)=userid
	Quit $$$OK
OnBeforeSaveError
	s $zt=""
 	Quit $$$OK
}

Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
{
	s $zt="OnAfterSave"
	s bdRowid=+$this.%Id()
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid))=0 $$$OK
	s updatestr=^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)
	q:(^DHCINTCT(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",12)
	s NewData=$g(^DHCINTCT(bdRowid))
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'SAVE',:optdate,:opttime,:userid,:bdStr,:NewData))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"%OnBeforeSave",$j,bdRowid)
	
	Quit $$$OK
OnAfterSave
	s $zt=""
 	Quit $$$OK
}

/// 删除
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	s $zt="OnDeleteError"
	;S tmpOBJ= ##class(User.INSUTarContrast).%Open(oid) 
	Set bdRowid = $lg(oid) 
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINTCT(bdRowid))=0 $$$OK
	s bdStr=^DHCINTCT(bdRowid)
	s ^CacheTemp(classname,"%OnDelete",$j,bdRowid)=bdStr	
	s userid=%session.Get("LOGON.USERID") 
	s ^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)=userid    
	q $$$OK
OnDeleteError
	s $zt=""
	q $$$OK
}

ClassMethod %OnAfterDelete(oid As %ObjectIdentity) As %Status [ Private, ServerOnly = 1 ]
{
	s $zt="OnafterDeleteError"
	s bdRowid=+$lg(oid)
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"%OnDelete",$j,bdRowid))=0 $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_^CacheTemp(classname,"%OnDelete",$j,bdRowid)
	s TableTypeCode=2
	i $d(^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data) values(UCase(:classname),:bdRowid,:TableTypeCode,'DELETE',:optdate,:opttime,:userid,:bdStr))
	i SQLCODE=0 d
	.k ^CacheTemp(classname,"%OnDelete",$j,bdRowid)
	.k ^CacheTemp(classname,"%OnDeleteUSERID",$j,bdRowid)
	
	q $$$OK
OnafterDeleteError
	s $zt=""
	q $$$OK
}

Trigger %InsertAfter [ Event = INSERT, Time = AFTER ]
{
	s $zt="InsertAfter"
	s bdRowid=+{INTCT_Rowid}
	s classname=$classname()
	s updatestr=$g(^DHCINTCT(bdRowid))
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=2
	s NewData=$g(^DHCINTCT(bdRowid))
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'INSERT',:optdate,:opttime,:userid,:bdStr,:NewData))
InsertAfter
	s $zt=""
	q $$$OK
}

}
