Class User.INSUDicData Extends (%Library.Persistent, web.INSUCacheJSON, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = INDID_Rowid, SqlTableName = INSU_DicData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// INDID_DicType
Property INDIDDicType As %Library.String(CAPTION = "字典类型", COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = INDID_DicType ];

/// INDID_DicCode
Property INDIDDicCode As %Library.String(CAPTION = "字典代码", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = INDID_DicCode ];

/// INDID_DicDesc
Property INDIDDicDesc As %Library.String(CAPTION = "字典描述", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = INDID_DicDesc ];

/// INDID_DicBill1
Property INDIDDicBill1 As %Library.String(CAPTION = "对照代码", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = INDID_DicBill1 ];

/// INDID_DicBill2
Property INDIDDicBill2 As %Library.String(CAPTION = "对照描述", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = INDID_DicBill2 ];

/// INDID_DicDemo
Property INDIDDicDemo As %Library.String(CAPTION = "备注", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = INDID_DicDemo ];

/// INDID_DicAuthorityFlag
Property INDIDDicAuthorityFlag As %Library.String(CAPTION = "授权标志", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = INDID_DicAuthorityFlag ];

/// INDID_DicOPIPFlag
Property INDIDDicOPIPFlag As %Library.String(CAPTION = "门诊住院标志", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = INDID_DicOPIPFlag ];

/// INDID_DicDefaultFlag
Property INDIDDicDefaultFlag As %Library.String(CAPTION = "默认标志", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = INDID_DicDefaultFlag ];

/// INDID_DicUseFlag
Property INDIDDicUseFlag As %Library.String(CAPTION = "使用标志", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = INDID_DicUseFlag ];

/// INDID_DicRelationFlag
Property INDIDDicRelationFlag As %Library.String(CAPTION = "关联字典", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = INDID_DicRelationFlag ];

/// INDID_DicBill3
Property INDIDDicBill3 As %Library.String(CAPTION = "数据关联类方法", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = INDID_DicBill3 ];

/// INDID_DicBill4
Property INDIDDicBill4 As %Library.String(CAPTION = "备用INDIDDicBill4", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = INDID_DicBill4 ];

/// INDID_DicBill5
Property INDIDDicBill5 As %Library.String(CAPTION = "备用INDIDDicBill4", COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = INDID_DicBill5 ];

/// INDID_HospDr
Property INDIDHospDr As %Library.String(CAPTION = "院区", COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = INDID_HospDr ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCINDID)</SqlIdExpression>
<SQLMap name="DataMasterMap">
<Data name="INDID_DicAuthorityFlag">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDID_DicBill1">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDID_DicBill2">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDID_DicBill3">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INDID_DicBill4">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INDID_DicBill5">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INDID_DicCode">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDID_DicDefaultFlag">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INDID_DicDemo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDID_DicDesc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDID_DicOPIPFlag">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDID_DicRelationFlag">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INDID_DicType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDID_DicUseFlag">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INDID_HospDr">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Global>^DHCINDID</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDicAuthority">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DicAuthority"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDID_DicAuthorityFlag}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDicAuthorityHosp">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDID_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"DicAuthority"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDID_DicAuthorityFlag}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDicType">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IType"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDID_DicType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>Sub</AccessType>
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDicTypeHosp">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDID_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITYPE"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDID_DicType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ITypeCode"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDID_DicType}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDID_DicCode}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCodeHosp">
<Global>^DHCINDID</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L7}</Expression>
<Field>INDID_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDID_HospDr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ITypeCode"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INDID_DicType}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDID_DicCode}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{INDID_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.INSUDicDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

// ------------------------------------------------------------------------------------------

/// 删除
Trigger BeforDelete [ Event = DELETE ]
{
  	s $zt="BeforDeleteError"
	s bdRowid=+{INDID_Rowid}
	q:bdRowid<1
	q:$d(^DHCINDID(bdRowid))=0
	s bdStr=^DHCINDID(bdRowid)
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
	s bdRowid=+{INDID_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforDelete",$j,bdRowid))=0 $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_^CacheTemp(classname,"BeforDelete",$j,bdRowid)
	s TableTypeCode=$p(bdStr,"^",2)
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
	s bdRowid=+{INDID_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINDID(bdRowid))=0 $$$OK
	s bdStr=^DHCINDID(bdRowid)
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
	s bdRowid=+{INDID_Rowid}
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^CacheTemp(classname,"BeforeUpdate",$j,bdRowid))=0 $$$OK
	s updatestr=^CacheTemp(classname,"BeforeUpdate",$j,bdRowid)
	q:(^DHCINDID(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"BeforeUpdateUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",2)
	s NewData=$g(^DHCINDID(bdRowid))
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
	q:$d(^DHCINDID(bdRowid))=0 $$$OK
	s bdStr=^DHCINDID(bdRowid)
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
	q:(^DHCINDID(bdRowid))=updatestr $$$OK
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	i $d(^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)) d
	.s userid=^CacheTemp(classname,"%OnBeforeSaveUSERID",$j,bdRowid)
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",2)
	s NewData=$g(^DHCINDID(bdRowid))
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
	;S tmpOBJ= ##class(User.INSUDicData).%Open(oid) 
	Set bdRowid = $lg(oid)
    ;Set INDIDDicType = tmpOBJ.INDIDDicType  
	q:bdRowid<1 $$$OK
	s classname=$classname()
	q:$d(^DHCINDID(bdRowid))=0 $$$OK
	s bdStr=^DHCINDID(bdRowid)
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
	s TableTypeCode=$p(bdStr,"^",2)
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
	s ^CacheTemp("%InsertAfter",1)=""
	s bdRowid=+{INDID_Rowid}
	s classname=$classname()
	s updatestr=$g(^DHCINDID(bdRowid))
	s optdate=+$h
	s opttime=$p($h,",",2)
	s userid="null"
	s bdStr=bdRowid_"^"_updatestr
	s TableTypeCode=$p(bdStr,"^",2)
	s NewData=$g(^DHCINDID(bdRowid))
	&sql(insert into CF_INSU_MI.DataLog (TableClassName,TableRowId,TableTypeCode,OptType,OptDate,OptTime,UserId,Data,NewData) values(UCase(:classname),:bdRowid,:TableTypeCode,'INSERT',:optdate,:opttime,:userid,:bdStr,:NewData))
InsertAfter
	s $zt=""
	q $$$OK
}

}
