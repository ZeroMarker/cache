/// 医生站命令行工具函数类
Class DHCDoc.Util.cmd Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 医生站命令集-帮助命令入口(不要在studio中直接运行，会死循环)
/// ;##class(DHCDoc.Util.cmd).DocHelp()
ClassMethod DocHelp(a As %String = "") As %String
{
	d ToChose()
	while(ChoseNum'="q"){
		if (ChoseNum=1){
			w $$ToTables(),!
			d ToChose("Y")
		}elseif (ChoseNum=2){
			w $$ToGet(),!
			d ToChose("Y")
		}elseif (ChoseNum=3){
			w $$ToGetIndex(),!
			d ToChose("Y")
		}elseif (ChoseNum=4){
			w $$ToExport(),!
			d ToChose("Y")
		}elseif (ChoseNum=5){
			
			w $$ToPrint(),!
			d ToChose("Y")
		}else{
			d ToChose()
		}
	}
	q ""
ToChose(qf="")
	if (qf="Y"){
		w $C(13,13,13),!
		READ "【选择运行命令】： ",ChoseNum,!
	}else{
		w $C(13,13,13),!
		w "目前DHCDoc.Util.cmd 提供以下帮助命令:",!
		w " 1: Tables "_"按照关键字查询SQLUser下表名和实体类名称",!
		w " 2: Get "_""_"查询User实体表的类对应的字段的所有的取值写法",!
		w " 3: GetIndex "_"获取对应实体类的索引结构",!
		w " 4: Export "_"导出Globle数据到对应的地址文件",!
		w " 5: print "_"打印表结构",!
		w " 请输入需要运行命令的序号1-5,输入q为退出!",!
		w $C(13,13,13),!
		READ "【选择运行命令】：",ChoseNum,!
	}
	q
ToExport()
	w $C(13,13,13),!
	w " 4: Export "_"导出Globle数据到对应的地址文件",!
	w "入参:List的指针,数据导出地址",!
	w "指针可以使用 m b=^GlobleName的方式获取lits参数b 运行方式为：w ..Export(.b,导出地址)",!
	w "list也就是组织数据的Globle现在最多支持5层数据结构的导出 ^GlobleName(sub1,sub2,sub3,sub4,sub5)"
	w $C(13,13,13),!
	READ "输入要导入的Globle的名字:",GlobLeName,!
	READ "导出地址: ",ExportAddress,!
	k b
	;当程序标准的私有程序块的时候(ProcedureBlock),要用出参接到返回的数据
	x ("(in,out){m out="_GlobLeName_"}","",.b)
	q ..Export(.b,ExportAddress)
ToGetIndex()
	w $C(13,13,13),!
	w " 3: GetIndex "_"获取对应实体类的索引结构",!
	w "入参:实体类名(可为关键字),rowid的名称(为空默认rowid),导出地址(不为空查询结果导出到对应的地址)",! ;,是否不外输出(N)(可为空)
	w $C(13,13,13),!
	READ "输入一个实体类关键字: ",UserName,!
	READ "rowid名称: ",rowidname,!
	READ "导出地址: ",ExportAddress,!
	;READ "不对外输出: ",NotWritFlag,!
	s NotWritFlag=""
	s:NotWritFlag'="Y" NotWritFlag="N"	
	q ..GetIndex(UserName,rowidname,ExportAddress,.a,NotWritFlag)
ToGet()
	w $C(13,13,13),!
	w " 2: Get "_""_"查询User实体表的类对应的字段的所有的取值写法",!
	w "入参:实体类名(可为关键字),rowid的名称(为空默认rowid),导出地址(不为空查询结果导出到对应的地址)",! ;,是否不外输出(N)(可为空)
	w "备注:只需要检索实体类某些字段时可以使用【实体类名+空格+字段关键字+,+字段关键字...】作为实体类名入参,多字段关键字用"",""分割",!
	w $C(13,13,13),! 
	READ "输入一个实体类关键字: ",UserName,!
	READ "rowid名称: ",rowidname,!
	READ "导出地址: ",ExportAddress,!
	;READ "不对外输出: ",NotWritFlag,!
	s NotWritFlag=""
	s:NotWritFlag'="Y" NotWritFlag="N"
	q ..Get(UserName,rowidname,ExportAddress,.a,)	
ToTables()
	w $C(13,13,13),!
	w " 1: Tables "_"按照关键字查询SQLUser下表名和实体类名称",!
	w "入参:表明关键字",! ;,是否不外输出(N)(可为空)
	w $C(13,13,13),!
	READ "输入一个表名关键字: ",UserName,!
	;READ "不对外输出: ",NotWritFlag,!
	s NotWritFlag=""
	s:NotWritFlag'="Y" NotWritFlag="N"
	q ..Tables(UserName,.a,NotWritFlag)
ToPrint()
	w $C(13,13,13),!
	w " 1: Tables "_"按照关键字查询SQLUser下表名和实体类名称",!
	w "入参:表明关键字",! ;,是否不外输出(N)(可为空)
	w $C(13,13,13),!
	READ "输入一个表名关键字: ",UserName,!
	;READ "不对外输出: ",NotWritFlag,!
	s NotWritFlag=""
	s:NotWritFlag'="Y" NotWritFlag="N"
	q ..Print(UserName,.a,NotWritFlag)
}

/// 获取对应的User文件夹下的所有的表结构
ClassMethod Tables(UserName = "", RtnArryList As %String, NotWritFlag As %String = "N") As %String
{
	if UserName=""  d
	.READ "输入一个表名: ",UserName,!
	
	s UserNameF=$ZCVT(UserName,"U")
	k RtnArryList
	Q:((UserName="")||(UserName="q")) 0
	//s Schema="SQLUser"
	s Schema=""
	for {
		s Schema=$O(^oddSQL(Schema))
		q:(Schema="")
		continue:($E(Schema,1,1)="%")
		//w Schema,!
		s table = ""
		f  {
			s table = $o(^oddSQL(Schema,table))
			q:table=""
			continue:(11'=$d(^oddSQL(Schema,table)))
			continue:$lg(^oddSQL(Schema,table),4)'="TABLE"
			s className = $$$GetExtentNameFromTableName(Schema,table)
			s SqlTableName=$$$GetIQNFromTableName(Schema,table)
			s IsNotClassName=($ZCVT(className,"U")'[UserNameF)&&($ZCVT(className,"U")'[UserNameF)
			s IsNotSqlTableName=($ZCVT(SqlTableName,"U")'[UserNameF)&&($ZCVT(SqlTableName,"U")'[UserNameF)
			//w className,!
			continue:(IsNotClassName=1)&&(IsNotSqlTableName=1)
			s ijs=$I(RtnArryList(0))
			w ijs_":"_"表名:"_SqlTableName_" 实体类:"_className,!
			if ($ZCVT(className,"U")=UserNameF)
				||($ZCVT(SqlTableName,"U")=UserNameF)
				||($ZCVT(SqlTableName,"U")=("SQLUSER."_UserNameF))
				||(("SQLUSER."_$ZCVT(SqlTableName,"U"))=UserNameF)
				||($ZCVT(className,"U")=("USER."_UserNameF))
				||(("USER."_$ZCVT(className,"U"))=UserNameF)
			{
				k RtnArryList
				s ijs=$I(RtnArryList(0))
				s RtnArryList(ijs)=SqlTableName_"^"_className
				 quit
			}
			s RtnArryList(ijs)=SqlTableName_"^"_className
		}
	}
    
    q +$G(RtnArryList(0))
}

/// 打印内结构
/// w ##class(DHCDoc.Util.cmd).Print("OEOrdItem","","")
/// w ##class(DHCDoc.Util.cmd).Print("DHCRoomComp","","")
/// w ##class(DHCDoc.Util.cmd).Print("DHCAppTestStatus","","")
ClassMethod Print(UserName = "", RtnArryList As %String, Desc As %String = "") As %String
{
	Q:UserName="" "-1^未找到对应得表"
	s TableName=""	;表名
	;键入模糊检索表名
	s rtnjs=..Tables(UserName,.RtnTables)
	if rtnjs>1 {
		s ^tmptan("Print",..%ZD(..%SysDate()),$ZT(..%SysTime(),2),UserName)=""
		w "不能查询到唯一的表: ",UserName,!
		q ""
	}
	s rtntabls=$G(RtnTables(1))
	s TableName=$P(rtntabls,"^",1)
	s myUserName=$P(rtntabls,"^",2)
	k RtnArryList ;用于指针的返回
	if '##class(%Dictionary.ClassDefinition).%ExistsId(myUserName){
		s ^tmptan("Print",..%ZD(..%SysDate()),$ZT(..%SysTime(),2),UserName)=""
		q "-1^未找到对应得表"
	} 
	s UserName=myUserName
	
	s ClassDefinition=##class(%Dictionary.ClassDefinition).%OpenId(UserName,0)
	if Desc="" s Desc=ClassDefinition.Description
	s RtnArryList=TableName_"^"_UserName_"^"_Desc

	s RowIdName=""
	&SQL(SELECT SqlRowIdName into :RowIdName from %Dictionary.StorageDefinition where parent=:UserName)
	if RowIdName="" s RowIdName=ClassDefinition.SqlRowIdName
	if RowIdName="" s RowIdName="ID"
	s RtnArryList("property",-10000)=$LB(RowIdName,"Key","%Integer","1","","","TRUE")
	s PackageName=$P(UserName,".",1,$L(UserName,".")-1)
	s className=$P(UserName,".",$L(UserName,"."),$L(UserName,"."))
	/// 1.字段含义
	Set rset = ##class(%ResultSet).%New("DHCDoc.Util.cmd:SelectProperty")
	Set rs = rset.Execute(PackageName,className,"")
	s myIdx=0
	While (rset.Next()) {
		s propertyName=rset.Data("propertyName")
		s propertyNode=rset.Data("propertyNode")
		s propertyDeli=rset.Data("propertyDeli")
		s propertyPiece=rset.Data("propertyPiece")
		s propertyType=rset.Data("propertyType")
		s propertyField=rset.Data("propertyField")
		s propertyColumn=rset.Data("propertyColumn")
		s propertyDesc=rset.Data("propertyDesc")
		s propertyCollection=rset.Data("propertyCollection")
		s propertyNote=rset.Data("propertyNote")
		s propertySqlComputeCode=rset.Data("propertySqlComputeCode")
		s Cardinality=rset.Data("Cardinality")
		s propertySqlComputeCode=$replace(propertySqlComputeCode,$C(10),"")
		s propertySqlComputeCode=$replace(propertySqlComputeCode,$C(13),"")
		if (propertyType'["%")&&(##class(%Dictionary.ClassDefinition).%ExistsId(propertyType)){
			s obj = ##class(%Dictionary.ClassDefinition).%OpenId(propertyType,0)
			if ($ISOBJECT(obj)&&(obj.SqlTableName'="")){
				s propertyType=obj.SqlTableName
			}
			s num=..Tables(propertyType,.propertyRtnTables)
			if (num=1){
				s propertyrtntabls=$G(propertyRtnTables(1))
				s propertyType=$P(propertyrtntabls,"^",1)
			}
		}elseif (propertyCollection["List"){
			if (propertyType["String"){
				s propertyType="List"
			}else {
				s propertyType="List of "_propertyType
			}
		}
		
		s PropertyDr=UserName_"||"_propertyName
		&SQL(SELECT Required, Parameters INTO :Required,:Parameters from %Dictionary.PropertyDefinition 
			where parent=:UserName and id=:PropertyDr)
		
		s constraint=""	;约束
		s Length=""		;字段长度
		//把约束转换成明文
		if $LISTVALID(Parameters){
			for i=1:1:$LISTLENGTH(Parameters){
				s Parameter=$listget(Parameters,i)
				continue:('$LISTVALID(Parameter))
				s KeyName=$listget(Parameter,1)
				s KeyValue=$listget(Parameter,2)
				
				if ($ZCVT(KeyName,"U")="DISPLAYLIST"){
					for j=1:1:$LENGTH(KeyValue,","){
						s $P(constraint,";",j)=$P($P(constraint,";",j),":",1)_":"_$P(KeyValue,",",j)
					}
				}elseif ($ZCVT(KeyName,"U")="VALUELIST"){
					if (KeyValue=",Y,N")||(KeyValue=",N,Y"){
						s propertyType="%Boolean"
					}
					for j=1:1:$LENGTH(KeyValue,","){
						s $P(constraint,";",j)=$P(KeyValue,",",j)_":"_$P($P(constraint,";",j),":",2)
					}
				}elseif ($ZCVT(KeyName,"U")="MAXLEN"){	;
					s Length=KeyValue
				}
			}
		}
		if (propertyColumn=""){
			s myIdx=myIdx-1
			s propertyColumn=myIdx
		}
		
		i propertyField="" s propertyField=propertyName
		if (Cardinality'="")&&(Cardinality'="parent"){
			s RtnArryList("Cardinality",propertyColumn)=$LB(propertyType,Cardinality,propertyField)
		}else{
			s propertyStr=$LB(propertyField,propertyDesc,propertyType,Required,constraint,Length,"",propertyNote,propertySqlComputeCode,Cardinality,"")
			s RtnArryList("property",propertyColumn)=propertyStr
		}
	}
	s RtnArryList=TableName_"^"_UserName_"^"_Desc
	
	;2. 表索引
	Set rset = ##class(%ResultSet).%New("DHCDoc.Util.cmd:SelectMaster")
	Set rs = rset.Execute(PackageName,className)
	While (rset.Next()) {
		;索引类型:索引名:索引结构:
		if (rset.Data("type")="index"){
			s RtnArryList("Index",$I(RtnArryList("Index")))=$LB(
				rset.Data("type"),rset.Data("indexName"),rset.Data("indexMasterData"),
				rset.Data("IndexCondition"),rset.Data("Unique"))
		}else{
			s RtnArryList("DataMaster",$I(RtnArryList("Index")))=$LB(
				rset.Data("type"),rset.Data("indexName"),rset.Data("indexMasterData"),
				rset.Data("IndexCondition"),rset.Data("Unique"))
		}
	}
	
	d ..ExportToExcel(.RtnArryList)
	q "成功"

	

ListStorage()
	;解析普通的List表的存储结构 按照系统默认的存储结构进行展开 只需要看存储结构Default 其他的索引不需要遍历
	if $D(^oddDEF(UserName,"s","Default"))'=0  d
	.s globlename=$G(^oddDEF(UserName,"s","Default",21)) ;GlobleName
	.s map=$G(^oddDEF(UserName,"s","Default",22)) ;Storage
	.k ListPro("WZ")
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s","Default","D",map,"V",jgid)) Q:jgid=""  d
	..s name=$G(^oddDEF(UserName,"s","Default","D",map,"V",jgid,21))
	..Q:name=""
	..s ListPro("sqlcomget",name)="$lg("_"$g("_globlename_"("_rowidname_")"_")"_","_jgid_")"
	..s ListPro("sqlcomget",name,"SX")=jgid ;排序属性
	q
SQLStorage(StroageName)
	
	;解析SQLStorge的存储结构 标准存储结构
	s rowidfile=$G(^oddDEF(UserName,"s",StroageName,29))
	s mapname=0
	f  s mapname=$O(^oddDEF(UserName,"s",StroageName,"S",mapname)) Q:mapname=""  d
	.s type1=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,5)) ;类型
	.Q:type1'="data" ;值需要看SQLStorage 中的data属性的 数据存储map 索引的不需要看
	.s globlename=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,24)) ;GlobleName
	.k ListPro("WZ")
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid)) Q:jgid=""  d
	..s wz=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid,21))
	..s idname=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid,22))
	..s wz=$tr($tr($tr(wz,"{",""),"}",""),"L","")
	..s:wz'="" ListPro("WZ",wz)=""
	.s globlelist=globlename_"("
	.;解析对应的globle的主体结构
	.s js=0,idnum=0
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"B",jgid)) Q:jgid=""  d
	..s js=js+1
	..s Code=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"B",jgid,24))
	..if $D(ListPro("WZ",js)) d
	...s idnum=idnum+1
	...if idnum=1  d
	....s Code="+"_rowidname
	...else  d
	....s Code="$P("_rowidname_",""||"","_idnum_")"
	..if js=1  d
	...s globlelist=globlelist_Code
	..else  d
	...s globlelist=globlelist_","_Code
	.;解析globle的存储数据节点结构
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid)) Q:jgid=""  d
	..s split=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,21))
	..s code=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,22))
	..s num=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,23))
	..s ListPro("sqlcomget_T",jgid,"S")=split
	..s ListPro("sqlcomget_T",jgid,"C")=code
	..s ListPro("sqlcomget_T",jgid,"N")=num
	..if code="" d
	...s ListPro("sqlcomget",jgid)="$P("_"$G("_globlelist_"))"_","_split_","_num_")"
	..else  d
	...if ((split="")&&(num="")) d
	....s ListPro("sqlcomget",jgid)="$G("_globlelist_","_code_","_"0"_"))"
	...else  d
	....s ListPro("sqlcomget",jgid)="$P("_"$G("_globlelist_","_code_"))"_","_split_","_num_")"	
	..s ListPro("sqlcomget",jgid,"SX")=code_$E("0000000",1,7-$L(num))_num ;排序属性
	..
	q
}

/***
  **Description      :按照公司统一格式导出到csr中
  **Author           :tanjishan
  **Time             :2022/12/09
  **debugger         :##class(DHCDoc.Util.cmd).ExportToExcel()
  **Parameter        :input
  **Returns          :%String
***/
ClassMethod ExportToExcel(ArryList As %String) As %String
{
	s TableName=$P(ArryList,"^")
	s ClassName=$P(ArryList,"^",2)
	s TableNameDesc=$P(ArryList,"^",3)
	//1、尝试知道公共的字段表头
	k TMPFieldArr
	s Index="",FieldNum=0
	for {
		s Index=$O(ArryList("property",Index))
		q:(Index="")
		s Str=$G(ArryList("property",Index))
		s FieldNum=FieldNum+1
		s propertyField=$lg(Str,1)			;SQL字段名
		for i=1:1:$Length(propertyField){
			s TMPStr=$E(propertyField,1,i)
			s Num=$I(TMPFieldArr(TMPStr))
		}
	}
	s PreStr=""
	s TMPStr=""
	for {
		s TMPStr=$O(TMPFieldArr(TMPStr))
		q:(TMPStr="")
		if (TMPFieldArr(TMPStr)'=FieldNum){
			quit
		}
		
		if ($L(PreStr)<$L(TMPStr)){
			s PreStr=TMPStr
		}
	}
	
	// 2、执行导出
	Set PhyDir = "/dthealth/app/dthis/web/temp/excel/doc/"
	if ('##class(%File).DirectoryExists(PhyDir)){
		d ##class(%File).CreateDirectory(PhyDir)
	}
	
	Set file=##class(%File).%New(PhyDir_TableName_".xls")
	Do file.Open("NWRS")
	k fileList
	S (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF)=""
	s A="表定义",D="模式",E="表的中文名",G="KingBase表名(同步修改表目录名称)",K="IRIS表名(勿动)",O="创建日期",Q="版本号"
	d SetColumn	;第一行
	s D="ho_his",E=TableNameDesc,G=TableName,K=TableName,Q="V1.0",R="返回表目录"
	d SetColumn	;第二行
	S O="创建人"
	d SetColumn	;第三行
	d SetColumn	;第四行
	s A="序号",B="KingBase字段名",C="IRIS字段名(勿动)",D="中文名",E="数据类型",F="长度",G="精度",H="NULL",I="主键"
	s J="关联表",K="计算属性",L="注释",M="处理方式",N="处理方式备注",O="值域定义",P="重要等级",Q="版本号"
	s S="NO",T="索引名",U="组合索引明细",V="条件",W="唯一性",Y="NO",Z="约束名"
	s AA="备注",AC="NO",AD="关联子表",AE="关联关系",AF="关联名称"
	d SetColumn	;第五行
	s LoopProperty=0,LoopIndex=0,LoopCardinality=0
	s NO="",Index="",IndexCard=""
	s SeqNo=0,IndexSeqNo=0,CardSeqNo=0
	for Loop=1:1:10000{
		s NO=$O(ArryList("property",NO))
		if (NO=""){
			s LoopProperty=1
		}
		if (LoopProperty=0){	//列数据遍历完之后就不再输出
			s Str=$G(ArryList("property",NO))
			s propertyField=$lg(Str,1)			;SQL字段名
			s propertyDesc=$lg(Str,2)			;字段描述
			s propertyType=$lg(Str,3)			;数据类型
			s Required=$lg(Str,4)				;非空
			s constraint=$lg(Str,5)				;约束
			s Length=$lg(Str,6)					;字符长度：精度
			s Primarykey=$lg(Str,7)					;主键
			s propertyNote=$lg(Str,8)					;备注
			s propertySqlComputeCode=$lg(Str,9)					;计算公式
			s Cardinality=$lg(Str,10)					;关系
			//propertyField_"^"_propertyDesc_"^"_propertyType_"^"_Required_"^"_constraint_"^"_Length_"^"_propertyNote
			s LinkTable=""
			if (propertyType["List"){
			}elseif (propertyType'["%"){
				s LinkTable=propertyType
				s propertyType="integer"
			}elseif (propertyType["Binary")||(propertyType["Stream"){
				s propertyType="Blob"
			}elseif (propertyType["%Decimal"){
				s propertyType="decimal"
			}elseif (propertyType["%Double"){
				s propertyType="double"
			}elseif (propertyType["%Float"){
				s propertyType="float"
			}elseif (propertyType["%Integer"){
				s propertyType="integer"
			}elseif (propertyType["Numeric"){
				s propertyType="numeric"
			}elseif (propertyType["String"){
				s propertyType="varchar"
			}elseif (propertyType["Date"){
				s propertyType="date"
			}elseif (propertyType["Time"){
				s propertyType="time with time zone"
			}elseif (propertyType["%TimeStamp"){
				s propertyType="timestamp"
			}elseif (propertyType["%Boolean"){
				s propertyType="boolean"
			}elseif (propertyType["List"){
				s propertyType="SET"
			}
			if (Cardinality="parent"){
				s P="5"
			}
			s SeqNo=SeqNo+1
			s A=SeqNo,B=$E(propertyField,$L(PreStr)+1,$L(propertyField)),C=propertyField,D=propertyDesc,E=propertyType,F=Length
			s H=$CASE(Required,"Y":"NOT NULL","1":"NOT NULL",:"")
			s I=Primarykey,J=LinkTable,K=propertySqlComputeCode,L=propertyNote,O=constraint
		}
		
		if (Loop>=1){	;从第12行开始输出索引
			s Index=$O(ArryList("Index",Index))
			if (Index=""){
				s LoopIndex=1
			}
			if (LoopIndex=0){
				s Str=$G(ArryList("Index",Index))
				s type=$LG(Str,1)					;SQL字段名
				s indexName=$LG(Str,2)				;字段描述
				s indexMasterData=$LG(Str,3)			;数据类型
				s indexMasterData=$replace(indexMasterData,"+","(integer) ")	//强转整型
				s IndexCondition=$LG(Str,4)			;索引条件
				s Unique=$LG(Str,5)			;索引条件
				if Unique=1 s Unique="Unique"
				if (type="index"){
					s S=$I(IndexSeqNo)
					s T=indexName
					s U=indexMasterData
					s V=IndexCondition
					s W=Unique					;约束
				}
			}
			s IndexCard=$O(ArryList("Cardinality",IndexCard))
			if (IndexCard=""){
				s LoopCardinality=1
			}
			if (LoopCardinality=0){
				s Str=$G(ArryList("Cardinality",IndexCard))
				s CardType=$LG(Str,1)			;关联表
				s Cardinality=$LG(Str,2)		;关联关系
				s CardName=$LG(Str,3)			;关联名称

				s AC=$I(CardSeqNo)		
				s AD=CardType
				s AE=Cardinality
				s AF=CardName
			}
			
		}
		quit:(LoopIndex="1")&&(LoopProperty="1")&&(LoopCardinality="1")
		d SetColumn
	}
	do file.Close()
	do file.%Close()
	Return 1
SetColumn

	s A=$replace(A,$C(10),"\n"),B=$replace(B,$C(10),"\n"),C=$replace(C,$C(10),"\n"),D=$replace(D,$C(10),"\n"),E=$replace(E,$C(10),"\n"),F=$replace(F,$C(10),"\n"),G=$replace(G,$C(10),"\n"),H=$replace(H,$C(10),"\n"),I=$replace(I,$C(10),"\n"),J=$replace(J,$C(10),"\n"),K=$replace(K,$C(10),"\n"),L=$replace(L,$C(10),"\n"),M=$replace(M,$C(10),"\n"),N=$replace(N,$C(10),"\n"),O=$replace(O,$C(10),"\n"),P=$replace(P,$C(10),"\n"),Q=$replace(Q,$C(10),"\n"),R=$replace(R,$C(10),"\n"),S=$replace(S,$C(10),"\n"),T=$replace(T,$C(10),"\n"),U=$replace(U,$C(10),"\n"),V=$replace(V,$C(10),"\n"),W=$replace(W,$C(10),"\n"),X=$replace(X,$C(10),"\n"),Y=$replace(Y,$C(10),"\n"),Z=$replace(Z,$C(10),"\n"),AA=$replace(AA,$C(10),"\n"),AB=$replace(AB,$C(10),"\n"),AC=$replace(AC,$C(10),"\n"),AD=$replace(AD,$C(10),"\n"),AE=$replace(AE,$C(10),"\n"),AF=$replace(AF,$C(10),"\n")
	s A=$replace(A,$C(13),"\r"),B=$replace(B,$C(13),"\r"),C=$replace(C,$C(13),"\r"),D=$replace(D,$C(13),"\r"),E=$replace(E,$C(13),"\r"),F=$replace(F,$C(13),"\r"),G=$replace(G,$C(13),"\r"),H=$replace(H,$C(13),"\r"),I=$replace(I,$C(13),"\r"),J=$replace(J,$C(13),"\r"),K=$replace(K,$C(13),"\r"),L=$replace(L,$C(13),"\r"),M=$replace(M,$C(13),"\r"),N=$replace(N,$C(13),"\r"),O=$replace(O,$C(13),"\r"),P=$replace(P,$C(13),"\r"),Q=$replace(Q,$C(13),"\r"),R=$replace(R,$C(13),"\r"),S=$replace(S,$C(13),"\r"),T=$replace(T,$C(13),"\r"),U=$replace(U,$C(13),"\r"),V=$replace(V,$C(13),"\r"),W=$replace(W,$C(13),"\r"),X=$replace(X,$C(13),"\r"),Y=$replace(Y,$C(13),"\r"),Z=$replace(Z,$C(13),"\r"),AA=$replace(AA,$C(13),"\r"),AB=$replace(AB,$C(13),"\r"),AC=$replace(AC,$C(13),"\r"),AD=$replace(AD,$C(13),"\r"),AE=$replace(AE,$C(13),"\r"),AF=$replace(AF,$C(13),"\r")
	s A=$replace(A,$C(9)," "),B=$replace(B,$C(9)," "),C=$replace(C,$C(9)," "),D=$replace(D,$C(9)," "),E=$replace(E,$C(9)," "),F=$replace(F,$C(9)," "),G=$replace(G,$C(9)," "),H=$replace(H,$C(9)," "),I=$replace(I,$C(9)," "),J=$replace(J,$C(9)," "),K=$replace(K,$C(9)," "),L=$replace(L,$C(9)," "),M=$replace(M,$C(9)," "),N=$replace(N,$C(9)," "),O=$replace(O,$C(9)," "),P=$replace(P,$C(9)," "),Q=$replace(Q,$C(9)," "),R=$replace(R,$C(9)," "),S=$replace(S,$C(9)," "),T=$replace(T,$C(9)," "),U=$replace(U,$C(9)," "),V=$replace(V,$C(9)," "),W=$replace(W,$C(9)," "),X=$replace(X,$C(9)," "),Y=$replace(Y,$C(9)," "),Z=$replace(Z,$C(9)," "),AA=$replace(AA,$C(9)," "),AB=$replace(AB,$C(9)," "),AC=$replace(AC,$C(9)," "),AD=$replace(AD,$C(9)," "),AE=$replace(AE,$C(9)," "),AF=$replace(AF,$C(9)," ")
	Do file.WriteLine(A_$c(9)_B_$c(9)_C_$c(9)_D_$c(9)_E_$c(9)_F_$c(9)_G_$c(9)_H_$c(9)_I_$c(9)_J_$c(9)_K_$c(9)_L_$c(9)_M_$c(9)_N_$c(9)_O_$c(9)_P_$c(9)_Q_$c(9)_R_$c(9)_S_$c(9)_T_$c(9)_U_$c(9)_V_$c(9)_W_$c(9)_X_$c(9)_Y_$c(9)_Z_$c(9)_AA_$c(9)_AB_$c(9)_AC_$c(9)_AD_$c(9)_AE_$c(9)_AF)
	S (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,AA,AB,AC,AD,AE,AF)=""
	Q
}

/// creater lxz
/// desc 用于查询User实体表的类对应的字段的所有的取值写法
/// input 
/// 		UserName:实体类名 例如:User.CTSex  
/// 		rowidname:输入时候使用的rowid的名字，为空默认为 rowid
/// 		RtnArryList 传入指针 返回所有的字段的取值
/// 		WritFlag Y表示W对应的数据
/// 		NotWritKey: Y表达式不输出key
/// OutPut  返回一共找打输出数据的数量 NUM
/// List 执行语句_$C(1)_语句中获取值的名称(结果)_$C(1)_关联表的名称_$C(1)_语句中使用参数的名称
/// w ##class(DHCDoc.Util.cmd).Get(UserName)
/// ;W $SYSTEM.OBJ.Dump(obj)
ClassMethod Get(UserName = "", rowidname As %String = "", ExportAdress As %String = "", RtnArryList As %String = "", NotWritFlag As %String = "N", NotWritKey As %String = "N") As %String
{
	;n (UserName,rowidname,RtnArryList,WritFlag)
	
	s findFiled=$P(UserName," ",2)
	s UserName=$P(UserName," ",1)
	Q:UserName="" "-1^未找到对应得表"
	;键入模糊检索表名
	if '##class(%Dictionary.ClassDefinition).%ExistsId(UserName)  d
	.if (NotWritFlag'="Y")  d
	..s rtnjs=..Tables(UserName,.RtnTables,NotWritFlag)
	..if rtnjs>1 d
	...READ "请输入想选择的表的序号: ",TabNum,!
	..else  d
	...s TabNum=1
	..if +TabNum>0 d
	...READ:findFiled="" "想要检索的字段关键字: ",findFiled,!
	...s rtntabls=$G(RtnTables(+TabNum))
	...s UserName=$P(rtntabls,"^",2)
	k RtnArryList ;用于指针的返回
	q:'##class(%Dictionary.ClassDefinition).%ExistsId(UserName) "-1^未找到对应得表"
	if (findFiled'=""){
		k findFiledList
		for iFile=1:1:$L(findFiled,","){
			s one=$P(findFiled,",",iFile)
			continue:one=""
			s findFiledList(one)=""
		}
	}
	s obj = ##class(%Dictionary.ClassDefinition).%OpenId(UserName,0)
	s rowidfile=""
	s JS=0
	k ListPro
	s:rowidname="" rowidname="rowid"
	;解析存储结构
	if (obj.StorageStrategy'=""){
		d SQLStorage(obj.StorageStrategy)
	}else{
		d ListStorage()
	}
	;获取表中的存储字段信息 按照字段属性 进行处理输出取值
	s myCount=obj.Properties.Count()
	f i=1:1:myCount{
		 s ObjOnePro=obj.Properties.GetAt(i)
		 ;主子表关联关系不需要解析 其实不用管在存储结构中并不存在关联关系的定义
		 ;if (ObjOnePro.Cardinality="children"){continue} 
		 s JS=JS+1
		 s SqlColumnNumber=ObjOnePro.SqlColumnNumber
		 s SequenceNumber=ObjOnePro.SequenceNumber
		 s Name=ObjOnePro.Name ;字段名
		 s SqlFieldName=ObjOnePro.SqlFieldName ;映射的SQL表名
		 s Description=ObjOnePro.Description		;描述
		 s findFlag1=$$findFiledComp(Name)
		 s findFlag2=$$findFiledComp(SqlFieldName)
		 continue:((findFlag1'="Y")&&(findFlag2'="Y"))
	
		 ;continue:(findFiled'="")&&(Name'[findFiled)&&(SqlFieldName'[findFiled)
		 s Type=ObjOnePro.Type
		 s Collection=ObjOnePro.Collection
		 s:((Type["%")&&(Type'["Date")&&(Type'["Time")) Type=""
		 if (Type'["%"){
			if ((Type["User")&&('##class(%Dictionary.ClassDefinition).%ExistsId(Type))){
				s Type=""
			}
			if (Type'["User"){
					s NewType="User."_Type
					if ('##class(%Dictionary.ClassDefinition).%ExistsId(NewType)){s Type=""}
					else{s Type=NewType}
			}
		 }
		 s:SqlColumnNumber="" SqlColumnNumber=(999+JS) ;防止List表未规定SqlColumnNumber 的情况 进行计数排序
		 ;获取对应得字段取值
		 s ListPro("FileGloble",SqlColumnNumber)=SqlFieldName_"^"_Name_"^"_SqlColumnNumber_"^"_SequenceNumber_"^"_Type_"^"_Description
		 if (obj.StorageStrategy'=""){s globlegetsub=SqlFieldName }else{s globlegetsub=Name}
		 continue:globlegetsub=""
		 if $D(ListPro("sqlcomget",globlegetsub)) d
		 .s pxsub=$G(ListPro("sqlcomget",globlegetsub,"SX")) ;排序信息 如果没有按照SqlColumnNumber 进行排序
		 .s:pxsub'="" SqlColumnNumber=pxsub
		 .s KeyLogo=""
		 .s:NotWritKey="Y" KeyLogo=$c(28)
		 .if Collection="list"  d
		 ..s ListPro("FileGloble",SqlColumnNumber,"Glob")="s "_Name_"="_KeyLogo_"+"_$G(ListPro("sqlcomget",globlegetsub)) _$c(1)_Name_$C(1)_$C(1)_rowidname_$c(1)_globlegetsub_$c(1)_Description
		 ..s code=ListPro("sqlcomget_T",globlegetsub,"C")
		 ..s:code'="" ListPro("FileGloble",SqlColumnNumber,"Glob",1)="s:(+"_Name_")'=0 "_Name_"="_KeyLogo_$P($G(ListPro("sqlcomget",globlegetsub)),code,1)_code_","_Name_"))"_$c(1)_Name_$C(1)_$C(1)_rowidname_$C(1)_""_$c(1)_Description		 
		 .else  if Type["User"  d
		 ..s ListPro("FileGloble",SqlColumnNumber,"Glob")="s "_Name_"="_KeyLogo_$G(ListPro("sqlcomget",globlegetsub))_$c(1)_Name_$C(1)_Type_$C(1)_rowidname_$C(1)_globlegetsub_$c(1)_Description ;" ;关联表"_Type
		 .else  d
		 ..s ListPro("FileGloble",SqlColumnNumber,"Glob")="s "_Name_"="_KeyLogo_$G(ListPro("sqlcomget",globlegetsub))_$c(1)_Name_$C(1)_$C(1)_rowidname_$C(1)_globlegetsub_$c(1)_Description
		 .if (Type["Date")&&(Type["%")  d
		 ..s ListPro("FileGloble",SqlColumnNumber,"Glob",1)="s "_Name_"Html="""" s:"_Name_"'="""" "_Name_"Html="_KeyLogo_"##Class(websys.Conversions).DateLogicalToHtml("_Name_")"_$c(1)_Name_"Html"_$C(1)_$C(1)_Name_$C(1)_""
		 .if (Type["Time")&&(Type["%")  d
		 ..s ListPro("FileGloble",SqlColumnNumber,"Glob",1)="s "_Name_"Html="""" s:"_Name_"'="""" "_Name_"Html="_KeyLogo_"$ZT("_Name_",2)"_$c(1)_Name_"Html"_$C(1)_$C(1)_Name_$C(1)_""_$c(1)_Description
	}
	d obj.%Close()
	
	s ExportFlag="N"
	if (ExportAdress'=""){
		s ExportFlag="Y"
		s file=##class(%File).%New(ExportAdress)
		s ExistsFlag=##class(%File).Exists(ExportAdress)
		if ExistsFlag'=1 d file.Open("N")
		d file.Close()
		s streamExport=##class(%FileCharacterStream).%New()
		s streamExport.Filename=ExportAdress
		//d stream.Clear()
		d ExportStr($C(10)_$C(10)_UserName_" "_$zd(+$H,3)_" "_$ZT($P($H,",",2),1))
		
	}
	;进行SQL表检索数据的输出
	s js=0
	s sub1=0
	f  s sub1=$O(ListPro("FileGloble",sub1)) Q:sub1=""  d
	.Q:$G(ListPro("FileGloble",sub1,"Glob"))=""
	.s js=js+1
	.w:NotWritFlag'="Y" $p($G(ListPro("FileGloble",sub1,"Glob")),$C(1),1)_" ;"_$p($G(ListPro("FileGloble",sub1,"Glob")),$C(1),3),!
	.d ExportStr($p($G(ListPro("FileGloble",sub1,"Glob")),$C(1),1)_" ;"_$p($G(ListPro("FileGloble",sub1,"Glob")),$C(1),3))
	.s RtnArryList(js)=$G(ListPro("FileGloble",sub1,"Glob"))
	.s sub2=0
	.f  s sub2=$O(ListPro("FileGloble",sub1,"Glob",sub2)) Q:sub2=""  d
	..Q:$G(ListPro("FileGloble",sub1,"Glob",sub2))=""
	..w:NotWritFlag'="Y" $p($G(ListPro("FileGloble",sub1,"Glob",sub2)),$c(1),1)_" ;"_$p($G(ListPro("FileGloble",sub1,"Glob",sub2)),$c(1),3),!
	..d ExportStr($p($G(ListPro("FileGloble",sub1,"Glob",sub2)),$c(1),1)_" ;"_$p($G(ListPro("FileGloble",sub1,"Glob",sub2)),$c(1),3))
	..s js=js+1
	..s RtnArryList(js)=$G(ListPro("FileGloble",sub1,"Glob",sub2))
	.;x $G(ListPro("FileGloble",sub1,"Glob"))
	
	d:ExportFlag="Y" streamExport.SaveStream()
	
	q js
ExportStr(WriteStr)
	if (ExportFlag="Y"){
		d streamExport.MoveToEnd()
		d streamExport.WriteLine(WriteStr)
	}
	q 
	
findFiledComp(ComPareCode)
	Q:findFiled="" "Y"
	s FindFlag="N"
	s findcode=0
	f  s findcode=$O(findFiledList(findcode)) Q:((findcode="")||(FindFlag="Y"))  d
	.s:ComPareCode[findcode FindFlag="Y"
	.s:$ZCVT(ComPareCode,"U")[$ZCVT(findcode,"U") FindFlag="Y"
	q FindFlag
ListStorage()
	;解析普通的List表的存储结构 按照系统默认的存储结构进行展开 只需要看存储结构Default 其他的索引不需要遍历
	if $D(^oddDEF(UserName,"s","Default"))'=0  d
	.s globlename=$G(^oddDEF(UserName,"s","Default",21)) ;GlobleName
	.s map=$G(^oddDEF(UserName,"s","Default",22)) ;Storage
	.k ListPro("WZ")
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s","Default","D",map,"V",jgid)) Q:jgid=""  d
	..s name=$G(^oddDEF(UserName,"s","Default","D",map,"V",jgid,21))
	..Q:name=""
	..s ListPro("sqlcomget",name)="$lg("_"$g("_globlename_"("_rowidname_")"_")"_","_jgid_")"
	..s ListPro("sqlcomget",name,"SX")=jgid ;排序属性
	q
SQLStorage(StroageName)
	
	;解析SQLStorge的存储结构 标准存储结构
	s rowidfile=$G(^oddDEF(UserName,"s",StroageName,29))
	s mapname=0
	f  s mapname=$O(^oddDEF(UserName,"s",StroageName,"S",mapname)) Q:mapname=""  d
	.s type1=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,5)) ;类型
	.Q:type1'="data" ;值需要看SQLStorage 中的data属性的 数据存储map 索引的不需要看
	.s globlename=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,24)) ;GlobleName
	.k ListPro("WZ")
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid)) Q:jgid=""  d
	..s wz=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid,21))
	..s idname=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"R",jgid,22))
	..s wz=$tr($tr($tr(wz,"{",""),"}",""),"L","")
	..s:wz'="" ListPro("WZ",wz)=""
	.s globlelist=globlename_"("
	.;解析对应的globle的主体结构
	.s js=0,idnum=0
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"B",jgid)) Q:jgid=""  d
	..s js=js+1
	..s Code=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"B",jgid,24))
	..if $D(ListPro("WZ",js)) d
	...s idnum=idnum+1
	...if idnum=1  d
	....s Code="+"_rowidname
	...else  d
	....s Code="$P("_rowidname_",""||"","_idnum_")"
	..if js=1  d
	...s globlelist=globlelist_Code
	..else  d
	...s globlelist=globlelist_","_Code
	.;解析globle的存储数据节点结构
	.s jgid=0
	.f  s jgid=$O(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid)) Q:jgid=""  d
	..s split=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,21))
	..s code=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,22))
	..s num=$G(^oddDEF(UserName,"s",StroageName,"S",mapname,"T",jgid,23))
	..s ListPro("sqlcomget_T",jgid,"S")=split
	..s ListPro("sqlcomget_T",jgid,"C")=code
	..s ListPro("sqlcomget_T",jgid,"N")=num
	..if code="" d
	...s ListPro("sqlcomget",jgid)="$P("_"$G("_globlelist_"))"_","_split_","_num_")"
	..else  d
	...if ((split="")&&(num="")) d
	....s ListPro("sqlcomget",jgid)="$G("_globlelist_","_code_","_"0"_"))"
	...else  d
	....s ListPro("sqlcomget",jgid)="$P("_"$G("_globlelist_","_code_"))"_","_split_","_num_")"	
	..s ListPro("sqlcomget",jgid,"SX")=code_$E("0000000",1,7-$L(num))_num ;排序属性
	..
	q
}

/// 获取对应的表中的所有的数据 暂时不发发布
/// w ##class(DHCDoc.Util.cmd).GetGlobleVal("User.CTSex","1")
ClassMethod GetGlobleVal(UserName, id, rowidName = "") As %String
{
	k rtnarry
	/*
	s:rowidName="" rowidName="rowid"
	s rtnjson={}
	s rtn=..Get(UserName,rowidName,"",.rtnarry,"Y")
	s sub=0
	f  s sub=$O(rtnarry(sub)) Q:sub=""  d
	.s globmes=$P($G(rtnarry(sub)),$c(1),1) ;执行语句
	.s jgname=$P($G(rtnarry(sub)),$c(1),2) ;结果名称
	.s username=$P($G(rtnarry(sub)),$c(1),3) ;关联表
	.s inputname=$P($G(rtnarry(sub)),$c(1),4) ;执行所需参数
	.s cs={}
	.if inputname=rowidName  d
	..d cs.%Set(inputname,id)
	.else  d
	..d cs.%Set(inputname,rtnjson.%Get(inputname))
	.s y=""
	.XECUTE ("("_inputname_","_jgname_"){ "_globmes_" }",cs.%Get(inputname), .y)
	.d rtnjson.%Set(jgname,y)
	q rtnjson.%ToJSON()
	*/
	q ""
}

/// 获取对应的索引结构
/// w ##class(DHCDoc.Util.cmd).GetIndex("User.CTSex")
ClassMethod GetIndex(UserName, rowidname As %String = "", ExportAdress As %String = "", RtnArry As %String = "", NotWritFlag As %String = "N") As %String
{
	k RtnArry
	Q:UserName="" "-1^未找到对应得表"
	;键入模糊检索表名
	if '##class(%Dictionary.ClassDefinition).%ExistsId(UserName)  d
	.if (NotWritFlag'="Y")  d
	..s rtnjs=..Tables(UserName,.RtnTables,NotWritFlag)
	..if rtnjs>1 d
	...READ "请输入想选择的表的序号: ",TabNum,!
	..else  d
	...s TabNum=1
	..if +TabNum>0 d
	...s rtntabls=$G(RtnTables(+TabNum))
	...s UserName=$P(rtntabls,"^",2)
	q:'##class(%Dictionary.ClassDefinition).%ExistsId(UserName) "-1^未找到对应得表"
	s obj = ##class(%Dictionary.ClassDefinition).%OpenId(UserName,0)
	s rowidfile=""
	s JS=0
	k ListPro
	s:rowidname="" rowidname="rowid"
	;获取表中的存储字段信息 按照字段属性 进行处理输出取值
	s myCount=obj.Properties.Count()
	f i=1:1:myCount{
		 s ObjOnePro=obj.Properties.GetAt(i)
		 ;主子表关联关系不需要解析 其实不用管在存储结构中并不存在关联关系的定义
		 ;if (ObjOnePro.Cardinality="children"){continue} 
		 s JS=JS+1
		 s SqlColumnNumber=ObjOnePro.SqlColumnNumber
		 s SequenceNumber=ObjOnePro.SequenceNumber
		 s Name=ObjOnePro.Name ;字段名
		 s SqlFieldName=ObjOnePro.SqlFieldName ;映射的SQL表名
		 s Type=ObjOnePro.Type
		 s Collection=ObjOnePro.Collection
		 s:SqlFieldName="" SqlFieldName=Name
		 continue:SqlFieldName=""
		 s ListPro("SqlName",SqlFieldName)=Name
		 s ListPro("SqlNameByName",Name)=SqlFieldName
		 
		 
	}
	;解析存储结构
	if (obj.StorageStrategy'=""){
		s StroageName=obj.StorageStrategy
		s indexdesc=0
		f  s indexdesc=$O(^oddDEF(UserName,"s",StroageName,"S",indexdesc)) Q:indexdesc=""  d
		.s Index=$G(^oddDEF(UserName,"s",StroageName,"S",indexdesc,5))
		.Q:Index'="index"
		.s GlobleName=$G(^oddDEF(UserName,"s",StroageName,"S",indexdesc,24))
		.
		.s rowidnum=0
		.s sub1=0
		.f  s sub1=$O(^oddDEF(UserName,"s",StroageName,"S",indexdesc,"R",sub1)) Q:sub1=""  d
		..s Lsub=$G(^oddDEF(UserName,"s",StroageName,"S",indexdesc,"R",sub1,21)) ;"{L3}"
		..s LsubCode=$G(^oddDEF(UserName,"s",StroageName,"S",indexdesc,"R",sub1,22))
		..s wz=$tr($tr($tr(Lsub,"{",""),"}",""),"L","")
		..s ListPro("RowID",LsubCode)=wz
		..s rowidnum=rowidnum+1
		.
		.s seqlstr=""
		.s IndexStr=GlobleName_"("
		.s js=0
		.s sub1=0
		.f  s sub1=$O(^oddDEF(UserName,"s",StroageName,"S",indexdesc,"B",sub1)) Q:sub1=""  d
		..s js=js+1
		..s IsSqlfil=""
		..s subcode=^oddDEF(UserName,"s",StroageName,"S",indexdesc,"B",sub1,24)
		..s:subcode["{" subcode=$tr($tr(subcode,"{",""),"}",""),IsSqlfil="Y"
		..s zh="0"
		..if subcode["$$ALPHAUP"  d
		...s zh=1
		...s subcode=$tr($tr(subcode,"$$ALPHAUP(",""),")","")
		...
		..
		..if $D(ListPro("RowID",subcode))  d
		...if rowidnum=1 d
		....s subcode=rowidname
		...else  d
		....s subcode=subcode_$G(ListPro("RowID",subcode))
		..else  d
		...;SQL字段名称换位取值名称
		...if $D(ListPro("SqlName",subcode)) d
		....if (seqlstr="")  d
		.....s seqlstr=subcode
		....else  d
		.....s seqlstr=seqlstr_","_subcode
		....s subcode=$G(ListPro("SqlName",subcode))
		..s:IsSqlfil="Y" subcode=$tr(subcode,"_","")
		..i zh=1  d
		...s subcode="$$ALPHAUP^SSUTIL4("_subcode_")" 
		..if js=1 d
		...s IndexStr=IndexStr_subcode
		..else  d
		...s IndexStr=IndexStr_","_subcode
		.s IndexStr=IndexStr_")"
		.s ListPro("List",indexdesc)=IndexStr_$C(1)_seqlstr
		.
	}else{
		s GlobleName=$G(^oddDEF(UserName,"s","Default",25))
		s sub1=0
		f  s sub1=$O(^oddDEF(UserName,"i",sub1)) Q:sub1=""  d
		.s subcode=$G(^oddDEF(UserName,"i",sub1,28))
		.s sqlstr=""
		.f sub2=1:1:$L(subcode,",")  d
		..s onesub=$P(subcode,",",sub2)
		..s SqlName=$G(ListPro("SqlNameByName",onesub))
		..if sqlstr=""  d
		...s sqlstr=SqlName
		..else  d
		...s sqlstr=sqlstr_","_SqlName
		.s IndexStr=GlobleName_"("""_sub1_""","_subcode_","_rowidname_")"_$C(1)_sqlstr
		.s ListPro("List",sub1)=IndexStr
	}
	
	s ExportFlag="N"
	if (ExportAdress'=""){
		s ExportFlag="Y"
		s file=##class(%File).%New(ExportAdress)
		s ExistsFlag=##class(%File).Exists(ExportAdress)
		if ExistsFlag'=1 d file.Open("N")
		d file.Close()
		s streamExport=##class(%FileCharacterStream).%New()
		s streamExport.Filename=ExportAdress
		//d stream.Clear()
		d ExportStr($C(10)_$C(10)_UserName_" "_$zd(+$H,3)_" "_$ZT($P($H,",",2),1))
	}
	
	s JS=0
	s sub1=0
	f  s sub1=$O(ListPro("List",sub1)) Q:sub1=""  d
	.s JS=JS+1
	.s RtnArry(JS)=sub1_$C(1)_$G(ListPro("List",sub1))
	.i NotWritFlag'="Y"  d
	..w sub1,!
	..w "  "_$P($G(ListPro("List",sub1)),$C(1),1),! //_" "_$P($G(ListPro("List",sub1)),$C(1),2),!
	..d ExportStr(sub1)
	..d ExportStr("  "_$P($G(ListPro("List",sub1)),$C(1),1))
	
	d:ExportFlag="Y" streamExport.SaveStream()
	q JS
ExportStr(WriteStr)
	if (ExportFlag="Y"){
		d streamExport.MoveToEnd()
		d streamExport.WriteLine(WriteStr)
	}
	q
}

/// 导出对应的 数据
/// w ##class(DHCDoc.Util.cmd).Export(.a,"D:/Export.txt")
ClassMethod Export(ExportList, ExportAdress As %String = "") As %String
{
	Q:ExportAdress="" 0
	s file=##class(%File).%New(ExportAdress)
	s ExistsFlag=##class(%File).Exists(ExportAdress)
	if ExistsFlag'=1 d file.Open("N")
	d file.Close()
	s streamExport=##class(%FileCharacterStream).%New()
	s streamExport.Filename=ExportAdress
	d streamExport.Clear()
	s sub1=0
	f  s sub1=$O(ExportList(sub1)) Q:sub1=""  d
	.s str1=$G(ExportList(sub1))
	.d:str1'="" ExportToFill(str1)
	.s sub2=0
	.f  s sub2=$O(ExportList(sub1,sub2)) Q:sub2=""  d
	..s str2=$G(ExportList(sub1,sub2))
	..d:str2'="" ExportToFill(str2)
	..s sub3=0
	..f  s sub3=$O(ExportList(sub1,sub2,sub3)) Q:sub3=""  d
	...s str3=$G(ExportList(sub1,sub2,sub3))
	...d:str3'="" ExportToFill(str3)
	...s sub4=0
	...f  s sub4=$O(ExportList(sub1,sub2,sub3,sub4)) Q:sub4=""  d
	....s str4=$G(ExportList(sub1,sub2,sub3,sub4))
	....d:str4'="" ExportToFill(str4)
	....s sub5=0
	....f  s sub5=$O(ExportList(sub1,sub2,sub3,sub4,sub5)) Q:sub5=""  d
	.....s str5=$G(ExportList(sub1,sub2,sub3,sub4,sub5))
	.....d:str5'="" ExportToFill(str5)
	d streamExport.SaveStream()
	q "导出完成"
ExportToFill(WriteStr)
	d streamExport.MoveToEnd()
	d streamExport.WriteLine(WriteStr)
	q
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Util.cmd","SelectProperty","User","OEOrdItem")
/// d ##class(%ResultSet).RunQuery("DHCDoc.Util.cmd","SelectProperty","User","PAAdm","")
/// d ##class(%ResultSet).RunQuery("%Dictionary.PropertyDefinition","Summary","User.DHCDocOPWorkflowItem")
Query SelectProperty(packageName As %String, className As %String, masterIndexName As %String = "", Namespace = "") As websys.Query(ROWSPEC = "propertyName:%String,propertyNode:%String,propertyDeli:%String,propertyPiece:%String,propertyType:%String,propertyField:%String,propertyColumn:%String,propertyDesc:%String,propertyCollection:%String,propertyNote:%String,propertySqlComputeCode:%String,Cardinality:%String")
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, packageName As %String, className As %String, masterIndexName As %String = "", Namespace = "") As %Status
{
	If Namespace="" Set Namespace=$Namespace
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
	i (packageName="")||(className="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	s classAllName=packageName_"."_className
	
	set StorageName=$O(^[Namespace]oddDEF(classAllName,"s",""))
	If StorageName="" Set StorageName="SQLStorage"
	if (masterIndexName="") {
		s masterIndexName=##class(web.Util.DHCJFClassGlobal).getMasterIndexName(packageName,className,Namespace)
	}
	set storageType =$G(^[Namespace]oddDEF(classAllName,"s",StorageName,5)) //"%Library.CacheStorage"
	Set CurNamespace = $Namespace
	Set $Namespace = Namespace
	// 列信息
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(classAllName)
	While(rsltSt.Next()) {
		s (propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn)=""
		set propertyName=rsltSt.Data("Name")
		set propertyId=classAllName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
		set propertyType=propObj.Type
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		set propertyColumn=propObj.SqlColumnNumber
		Set propertyDesc = propObj.Description
		s SequenceNumber=propObj.SequenceNumber
		s Cardinality=propObj.Cardinality
		
		s UDLName="T"_(SequenceNumber-1)
		s propertyNote=""
		k UDLTextList
		if ($D(^oddDEF(classAllName,"u",UDLName))){
			//不规范注释信息
			s UDLTextObj=##Class(%Dictionary.UDLTextDefinition).%OpenId(classAllName_"||"_UDLName,0)
			if ($ISOBJECT(UDLTextObj)&&(UDLTextObj.Content.Size>0)){
				s propertyNote=UDLTextObj.Content.Read()
			}
		}
		Set Collection = propObj.Collection
		Set SqlComputeCode= propObj.SqlComputeCode
		
		set ssmddID=classAllName_"||"_StorageName_"||"_masterIndexName_"||"_propertyField
		if (storageType["CacheStorage")||(storageType["%Storage.Persistent"){
			Set ssmddName = ""
			For {
				Set ssmddName = $O(^[Namespace]oddDEF(classAllName,"s",StorageName,"D",masterIndexName,"V",ssmddName))
				quit:ssmddName=""
				Set ssmddValue = $G(^[Namespace]oddDEF(classAllName,"s",StorageName,"D",masterIndexName,"V",ssmddName,21))
				//w ssmddName_","_ssmddValue_","_propertyName_"..."
				Quit:ssmddValue=propertyName
			}
			Set propertyNode=""
			set propertyDeli="$lg"
			Set propertyPiece=ssmddName
		}else{
			set ssmdd=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(ssmddID,0)
			if (ssmdd'="") {
				set propertyNode=ssmdd.Node
				set propertyDeli=ssmdd.Delimiter
				set propertyPiece=ssmdd.Piece
				
			}
		}
		d OutputRowProperty
	}
	Set $Namespace = CurNamespace
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowProperty
	
	set Data=$lb(propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn,propertyDesc,Collection,propertyNote,SqlComputeCode,Cardinality)
 	Set ^[CurNamespace]CacheTemp(repid,ind)=Data  //写Global时
 	Set ind=ind+1
}

/// input: 包名,类名
/// desc:  查询表的结构
/// d ##class(%ResultSet).RunQuery("DHCDoc.Util.cmd","SelectMaster","User","OEOrdItem")
/// d ##class(%ResultSet).RunQuery("DHCDoc.Util.cmd","SelectMaster","User","DHCDocOPWorkflowItem")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","User","DHCMedAdvRepNotes")
/// d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectMaster","PIS","DHCPISARCHIVECLASS","PIS")
Query SelectMaster(packageName As %String, className As %String, Namespace = "") As websys.Query(ROWSPEC = "type:%String:索引类型,indexName:%String:索引名,indexMasterData:%String:索引结构,IndexCondition:%String:条件索引,Unique:%String:索引唯一")
{
}

ClassMethod SelectMasterExecute(ByRef qHandle As %Binary, packageName As %String, className As %String, Namespace = "") As %Status
{
	If Namespace="" Set Namespace=$Namespace
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
	set classAllName=packageName_"."_className
	Set Unique="",IndexCondition=""
	Set ss = "" For  Set ss =$O(^[Namespace]oddDEF(classAllName,"s",ss)) Q:ss=""  d
	. ; 
	.Set stoType = $G(^[Namespace]oddDEF(classAllName,"s",ss,5)) ; %Library.CacheStorage
	.if (stoType["CacheStorage")||(stoType["%Storage.Persistent")  d 
	. . Set type="data"
	. . Set indexGlobalName=^[Namespace]oddDEF(classAllName,"s",ss,24)
	. . Set indexName = $G(^[Namespace]oddDEF(classAllName,"s",ss,22)) ;索引名
	. . Set stoIndex=0 for  set stoIndex=$O(^[Namespace]oddDEF(classAllName,"s",ss,"D",indexName,"V",stoIndex)) Quit:stoIndex=""  D 
	. . . Set $list(indexSubList,stoIndex) = $G(^[Namespace]oddDEF(classAllName,"s",ss,"D",indexName,"V",stoIndex,21))
	. . Set indexMasterData=indexGlobalName_"("_$lts(indexSubList,",")_")"
	. . Set indexMasterData=$Replace($Replace(indexMasterData,"{",""),"}","")
	. . d OutputRowMaster
	. . Set type="index"
	. . Set indexGlobalName=^[Namespace]oddDEF(classAllName,"s",ss,25)
	. . Set indexName = $G(^[Namespace]oddDEF(classAllName,"s",ss,22)) ;索引名
	. . Set stoIndex="" For  Set stoIndex=$O(^[Namespace]oddDEF(classAllName,"i",stoIndex)) Quit:stoIndex=""  d
	. . . Set indexName = stoIndex
	. . . Set indexMasterData=^[Namespace]oddDEF(classAllName,"i",stoIndex,28)
	. . . Set Unique=$G(^[Namespace]oddDEF(classAllName,"i",stoIndex,31))
	. . . Set indexMasterData=$Replace($Replace(indexMasterData,"{",""),"}","")
	. . . d OutputRowMaster
	.else  d
	. . Set si="" For  Set si=$O(^[Namespace]oddDEF(classAllName,"s",ss,"S",si)) Q:si=""  d
	. . . Set type = $G(^[Namespace]oddDEF(classAllName,"s",ss,"S",si,5))
	. . . Set indexName=si
	. . . Set indexGlobalName = $G(^[Namespace]oddDEF(classAllName,"s",ss,"S",si,24))
	. . . Set IndexCondition=$G(^[Namespace]oddDEF(classAllName,"s",ss,"S",si,21))
	. . . Set indexSubList = $lb(""),indexSub="",Count=1
	. . . For  Set indexSub=$O(^[Namespace]oddDEF(classAllName,"s",ss,"S",si,"B",indexSub)) Q:indexSub=""  d
	. . . . Set Node=$G(^[Namespace]oddDEF(classAllName,"s",ss,"S",si,"B",indexSub,24))
	. . . . q:($E(Node,1,1)="""")&&($E(Node,$L(Node),$L(Node))="""")
	. . . . q:((+Node)=Node)
	. . . . Set $list(indexSubList,Count)=Node,Count=Count+1
	. . . ;Set indexMasterData=indexGlobalName_"("_$lts(indexSubList,",")_")"
	. . . Set indexMasterData=$lts(indexSubList,",")
	. . . Set indexMasterData=$Replace($Replace(indexMasterData,"{",""),"}","")
	. . . d OutputRowMaster
	Quit $$$OK
OutputRowMaster
	
	set Data=$lb($g(type),$g(indexName),$g(indexMasterData),IndexCondition,Unique)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

/// Creator：李旭  
/// CreatDate：2022-09-03
/// Description：查询表结构的索引JSON信息(treegrid数据视图).
/// 			数据也可调用d ##class(%ResultSet).RunQuery("web.Util.DHCJFClassGlobal","SelectProperty","User","DocInterfaceMethod","")获取
/// Input：nameSpace:命名空间、packageName:包名、className:类名
/// Output：Json串
/// Debug：w ##class(DHCDoc.Util.cmd).GetTableInfoJSON("DHC-APP","User","CTSex")
ClassMethod GetTableInfoJSON(nameSpace = "DHC-APP", packageName = "User", className, rowid = "")
{
	s result={}
    s result.Total=0
    s result.rows=[]
	Q:(nameSpace="")!(packageName="")!(className="") result.%ToJSON()
	
	s List=[]
	s ClassName=packageName_"."_className
	d ##class(DHCDoc.Util.cmd).GetIndex(ClassName,"","",.IndexArr,"Y")
	d ##class(DHCDoc.Util.cmd).Get(ClassName,rowid,"",.PropertyArr,"Y","Y")
	;索引输出
	s Obj={"id":"Master_1","code":"Index","state":"closed"}
	d List.%Push(Obj)
	s Seq=""
	for{
		s Seq=$o(IndexArr(Seq))
		Q:Seq=""
		s OID="Index_"_Seq
		s OType="Index"
		s OParentID="Master_1"
		s IndexInfo=$g(IndexArr(Seq))
		s OCode=$p(IndexInfo,$c(1),1)
		s Expression=$p(IndexInfo,$c(1),2)
		s Description=""
		do TableInfoObj
	}
	;属性输出
	s Obj={"id":"Master_2","code":"Data"}
	d List.%Push(Obj)
	s Seq=""
	for{
		s Seq=$o(PropertyArr(Seq))
		Q:Seq=""
		s OID="Property_"_Seq
		s OType="Property"
		s OParentID="Master_2"
		s PropertyInfo=$g(PropertyArr(Seq))
		s PropertyInfo=$p(PropertyInfo,$c(28),2)
		s PropertyInfo=$replace(PropertyInfo,"$P","$p")
		s PropertyInfo=$replace(PropertyInfo,"$G","$g")
		s PropertyInfo=$replace(PropertyInfo,"$ZT","$zt")
		s Expression=$p(PropertyInfo,$c(1),1)
		s OCode=$p(PropertyInfo,$c(1),2)
		s PropertyCode=$p(PropertyInfo,$c(1),5)
		s Description=$p(PropertyInfo,$c(1),6)
		do TableInfoObj
	}
	s result.rows=List
	Q result.%ToJSON()

TableInfoObj
	s Obj={}
	s Obj."id"=OID
	s Obj."code"=OCode
	s Obj."name"=OCode
	s Obj."type"=OType 
	s Obj."expression"=Expression
	s Obj."description"=$g(Description)
	s Obj."propertycode"=$g(PropertyCode)
	s Obj."_parentId"=OParentID
	d List.%Push(Obj)
	Q ""
}

/// Creator：李旭  
/// CreatDate：2022-09-03
/// Description：通过命名空间、包名、类名检索存在的表名
/// Input：nameSpace:命名空间、packageName:包名、className:类名
/// Output：Json串
/// Debug：w ##class(DHCDoc.Util.cmd).GetTabNameList("DHC-APP","User","paa")
ClassMethod GetTabNameList(nameSpace = "DHC-APP", packageName = "User", className)
{
	s List=[]
	Q:(nameSpace="")!(packageName="")!(className="") List.%ToJSON()
	
	set rs=##class(%ResultSet).%New("web.Util.DHCJFClassGlobal:SelectClass")
	set sc=rs.Execute(packageName,className)  
	while rs.%Next() { 	
		s Obj={}
		s Obj.id=rs.GetData(1)
		s Obj.text=rs.GetData(1)
		d List.%Push(Obj)
	}
	Q List.%ToJSON()
}

/// Creator：李旭  
/// CreatDate：2022-09-03
/// Description：通过命名空间、包名、类名检索存在的表名
/// Input：nameSpace:命名空间、packageName:包名、className:类名
/// Output：Json串
/// Debug：w ##class(DHCDoc.Util.cmd).GetTabName(,"CTSex")
/// 	 w ##class(DHCDoc.Util.cmd).GetTabName("DOC.Interface","TestTable")
ClassMethod GetTabName(PackName = "User", ClassName)
{
	s List=[]
	Q:(PackName="")||(ClassName="") "-1^缺少入参"
	s UserName=PackName_"."_ClassName
	Q:'##class(%Dictionary.ClassDefinition).%ExistsId(UserName) "-1^未找到对应得表"
	s Obj=##class(%Dictionary.ClassDefinition).%OpenId(UserName,0)
	s SqlTableName=Obj.SqlTableName
	s (PreTableName,TableName)=""
	i PackName="User" s PreTableName="SQLUser"
	e  s PreTableName=$tr(PackName,".","_")
	i SqlTableName="" s TableName=PreTableName_"."_ClassName
	e  s TableName=PreTableName_"."_SqlTableName
	Q "0^"_TableName
}

/// 获取SQL语句 
/// Debug：w ##class(DHCDoc.Util.cmd).GetSQLStr(,"CTSex")
ClassMethod GetSQLStr(PackName = "User", ClassName, ProStr, NodeStr)
{
	s TableNameStr=..GetTabName(PackName,ClassName)
	s Code=$p(TableNameStr,"^",1)
	s TableName=$p(TableNameStr,"^",2)
	Q:Code'=0 TableName
	
	s Str="&sql(SELECT "_ProStr_" Into "_NodeStr_"\\n"
	s Str=Str_"FROM "_TableName_ " WHERE %ID=:rowid)"
	Q Str
}

}
