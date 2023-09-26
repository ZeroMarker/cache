Import SQLUser

/// Creator: 		bianshuai
/// CreateDate: 	2018-01-03
/// Descript: 		病理申请业务类
Class web.DHCAppPisMaster Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入病理申请内容
/// Input:     PisType-申请类型(病理申请单类别)，mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).Insert("MOL","","MOL^^11544||1^345^124^4634^110^^^^^^^^MOL&1^^^^^^^^&")
ClassMethod Insert(PisType As %String, PisID As %String, mListData As %String) As %String
{
	N (PisType, PisID, mListData)
	s ^tempqujian("Insert")=PisType_","_PisID_","_mListData
	/// 细胞申请内容
	i PisType="CYT" s PisID=..InsCytExn(PisID, mListData)
	/// HPV申请内容
	i PisType="HPV" s PisID=..InsHPV(PisID, mListData)
	/// 外院申请内容
	i PisType="CON" s PisID=..InsConsult(PisID, mListData)
	/// 尸检申请内容
	i PisType="APY" s PisID=..InsAutoPsy(PisID, mListData)
	/// TCT申请内容
	i PisType="TCT" s PisID=..InsGynWon(PisID, mListData)
	/// 活体申请内容
	i PisType="LIV" s PisID=..InsLivCell(PisID, mListData)
	/// 分子病理申请内容
	i PisType="MOL" s PisID=..InsMolecular(PisID, mListData)
	
	Q PisID
}

/// Descritp:  插入病理细胞申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsCytExn("")
ClassMethod InsCytExn(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertCytExn(mListData)
	E  D
	.s PisID=..UpdateCytExn(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理细胞申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertCytExn("")
ClassMethod InsertCytExn(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 传染病史
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatInfDis(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	Q PisID
}

/// Descritp:  更新病理细胞申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateCytExn("")
ClassMethod UpdateCytExn(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID,mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 传染病史
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatInfDis(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-17"

	TC
	Q PisID
}

/// Descritp:  插入病理细胞申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsHPV("")
ClassMethod InsHPV(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertHPV(mListData)
	E  D
	.s PisID=..UpdateHPV(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理HPV申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertHPV("")
ClassMethod InsertHPV(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",5)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 检测方法
	s Err=..InsPisTesMet(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"

	/// 临床诊断
	s Err=..InsPisTesDiag(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-14"

	/// 治疗方式
	s Err=..InsPisTreatMet(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-15"

	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	/// 取材信息
	s ListData=$p(mListData,"&",6)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	Q PisID
}

/// Descritp:  更新病理HPV申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateHPV("")
ClassMethod UpdateHPV(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID, mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",5)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 检测方法
	s Err=..InsPisTesMet(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"

	/// 临床诊断
	s Err=..InsPisTesDiag(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-14"

	/// 治疗方式
	s Err=..InsPisTreatMet(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-15"

	/// 取材信息
	s ListData=$p(mListData,"&",6)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	Q PisID
}

/// Descritp:  插入病理细胞申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsAutoPsy("")
ClassMethod InsAutoPsy(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertAutoPsy(mListData)
	E  D
	.s PisID=..UpdateAutoPsy(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理尸检申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertAutoPsy("")
ClassMethod InsertAutoPsy(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 尸检信息
	s Err=..InsPisAutoPsy(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-14"

	TC
	Q PisID
}

/// Descritp:  插入病理尸检申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateAutoPsy("")
ClassMethod UpdateAutoPsy(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID, mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 尸检信息
	s Err=..InsPisAutoPsy(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"

	TC
	Q PisID
}

/// Descritp:  插入病理外院申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsConsult("")
ClassMethod InsConsult(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertConsult(mListData)
	E  D
	.s PisID=..UpdateConsult(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理外院申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertAutoPsy("")
ClassMethod InsertConsult(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 会诊信息
	s Err=..InsPisConsult(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"

	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	TC
	Q PisID
}

/// Descritp:  更新病理外院申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateConsult("")
ClassMethod UpdateConsult(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID,mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 会诊信息
	s Err=..InsPisConsult(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	Q PisID
}

/// Descritp:  插入病理TCT申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsConsult("")
ClassMethod InsGynWon(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertGynWon(mListData)
	E  D
	.s PisID=..UpdateGynWon(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理TCT申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertGynWon("")
ClassMethod InsertGynWon(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 妇科信息
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisGynWon(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 病人病历
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatRec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 病理标本  妇科TCT必须生成唯一标本
	s ListData="1^^宫颈脱落细胞^^1"
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	/// 临床诊断
	s $p(mListData,"&",3)=$p(mListData,"&",5)
	s Err=..InsPisTesDiag(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	Q PisID
}

/// Descritp:  更新病理TCT申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateGynWon("")
ClassMethod UpdateGynWon(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID, mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 妇科信息
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisGynWon(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 病人病历
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatRec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 病理标本  妇科TCT必须生成唯一标本
	s ListData="1^^宫颈脱落细胞^^1"
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 临床诊断
	s $p(mListData,"&",3)=$p(mListData,"&",5)
	s Err=..InsPisTesDiag(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	TC
	Q PisID
}

/// Descritp:  插入病理活体组织申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsLivCell("")
ClassMethod InsLivCell(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	i PisID="" D
	.s PisID=..InsertLivCell(mListData)
	E  D
	.s PisID=..UpdateLivCell(PisID, mListData)
	Q PisID
}

/// Descritp:  插入病理活体组织申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertLivCell("")
ClassMethod InsertLivCell(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 妇科信息
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisGynWon(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 传染病史
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatInfDis(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 肿瘤信息
	s ListData=$p(mListData,"&",5)
	s Err=..InsPisTumour(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 病理标本
	s ListData=$p(mListData,"&",6)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-16"
	
	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-17"
	
	TC
	Q PisID
}

/// Descritp:  更新病理活体组织申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateLivCell("")
ClassMethod UpdateLivCell(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID, mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	
	/// 妇科信息
	s ListData=$p(mListData,"&",2)
	s Err=..InsPisGynWon(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"

	/// 取材信息
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisCutBas(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 传染病史
	s ListData=$p(mListData,"&",4)
	s Err=..InsPisPatInfDis(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 肿瘤信息
	s ListData=$p(mListData,"&",5)
	s Err=..InsPisTumour(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	/// 病理标本
	s ListData=$p(mListData,"&",6)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-16"
		
	TC
	Q PisID
}

/// Descritp:  插入病理分子病理申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsLivCell("")
ClassMethod InsMolecular(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)

	s Err = 0
	TS
	i PisID="" D
	./// 根据检测项目拆分申请单
	.s ListData=..DealPisByTesItm(mListData)
	.F i=1:1:$L(ListData,"!!") Q:Err'=0  D
	..s mListData=$p(ListData,"!!",i)
	..s ID=..InsertMolecular(mListData)
	..i ID<0 s Err=PisID
	..Q:ID<0 
	..s PisID=$s(PisID'="":PisID_"^"_ID,1:ID)  ///申请表ID串
	E  D
	.s PisID=..UpdateMolecular(PisID, mListData)
	
	i Err'=0 tro
	q:Err'=0 Err
	TC
	Q PisID
	
#;	i PisID="" D
#;	.s PisID=..InsertMolecular(mListData)
#;	E  D
#;	.s PisID=..UpdateMolecular(PisID, mListData)
#;	Q PisID
}

/// Descritp:  根据检测项目拆分病理分子病理申请单
/// w ##Class(web.DHCAppPisMaster).DealPisByTesItm("1^2^T@Y@U")
ClassMethod DealPisByTesItm(mListData As %String) As %String
{
	n (mListData)
	
	k TmpPisTesItem
	s TesItems=$p(mListData,"&",3)      /// 检测项目
	F i=1:1:$L(TesItems,"@")  D
	.s TesItmID=+$p(TesItems,"@",i)     /// 检测方法ID
	.s TesCatID=+$p($g(^DHCAPPTI(TesItmID)),"^",7)
	.s TmpPisTesItem(TesCatID,TesItmID)=""
	.

	s TmpListData="", index=""
	F  s index=$o(TmpPisTesItem(index)) Q:index=""  D
	.s index2="", itemID=""
	.F  s index2=$o(TmpPisTesItem(index,index2)) Q:index2=""  D
	..i itemID="" s itemID=index2
	..E  s itemID=itemID_"@"_index2
	.s $p(mListData,"&",3)=itemID
	.
	.i TmpListData="" s TmpListData=mListData
	.E  s TmpListData=TmpListData_"!!"_mListData
	.
	
	Q TmpListData
}

/// Descritp:  插入病理分子病理申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertMolecular("")
ClassMethod InsertMolecular(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=..InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 取材信息
	s ListData=$p(mListData,"&",2)
	//s Err=..InsPisCutBas(PisID,ListData)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 检测方法
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisTesItm(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 检测方法绑定医嘱
	s Err=..InsPisTesItmArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-14"	
	
	/// 插入医嘱
	//s Err = ..InsPisOeori(PisID)
	i Err'=0 tro
	Q:Err'=0 "-15"
	
	TC
	Q PisID
}

/// Descritp:  更新病理分子病理申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).UpdateMolecular("")
ClassMethod UpdateMolecular(PisID As %String, mListData As %String) As %String
{
	N (PisID, mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=..UpdPisMaster(PisID, mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 删除相关字表内容重新插入
	s Err=..DelPisMasSubTable(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 取材信息
	s ListData=$p(mListData,"&",2)
	//s Err=..InsPisCutBas(PisID,ListData)
	s Err=..InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 检测方法
	s ListData=$p(mListData,"&",3)
	s Err=..InsPisTesItm(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 检测方法绑定医嘱
	//s Err=..InsPisTesItmArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	TC
	Q PisID
}

/// Descritp:  插入病理主表
ClassMethod InsPisMaster(mListData As %String) As %String
{
	n (mListData)
	s ListData=$p(mListData,"&")
	s PisNo=..GetCurMaxNo("PIS"_$zd(+$H,8),"5")  ///单号
	s EpisodeID=$p(ListData,"^",3)   ///EpisodeID
	s arUserID=$p(ListData,"^",4)    ///申请医生
	s arLocID=$p(ListData,"^",5)     ///申请科室
	s EmgFlag=$p(ListData,"^",6)     ///加急标志
	s FrostFlag=$p(ListData,"^",7)   ///冰冻标志
	s FrostFlag=$case(FrostFlag,"是":"Y","否":"N",:FrostFlag)
	s FoundDate=$p(ListData,"^",8)   ///人乳头病毒发现日期
	//s:FoundDate'="" FoundDate=$zdh(FoundDate,3)
	s:FoundDate'="" FoundDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(FoundDate)
	s medRecord=$p(ListData,"^",9)   ///临床病历
	s medDiag=$p(ListData,"^",10)    ///临床诊断
	s HepatitisB=$p(ListData,"^",11) ///乙肝病史
	s OperRes=$p(ListData,"^",12)    ///手术所见
	s PisType=$p(ListData,"^",13)    ///申请类型
	s arOeori=$p(ListData,"^",14)    ///医嘱ID
	s arStatus="N"				     ///申请状态
	i arOeori'="" s arStatus="Y"
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arUserID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (practiceFlag=1){
		s arStatus="I"	
	}
	s arCreateDate=..%SysDate()   		     ///申请日期
	s arCreateTime=..%SysTime()      ///申请时间
	s PrevHis=$p(ListData,"^",15)    ///既往手术史 18-7-3
	&SQL(Insert Into DHC_AppPisMaster(AP_Adm_Dr,AP_FrostFlag,AP_EmgFlag,AP_No,AP_CreateDoc_Dr,AP_CreateDate,AP_CreateTime,AP_Loc_Dr,AP_Status,AP_MedRecord,AP_MedDiag,AP_HepatitisB,AP_OperRes,AP_PerPapVirus,AP_Type,AP_DisHistory)
		values(:EpisodeID,:FrostFlag,:EmgFlag,:PisNo,:arUserID,:arCreateDate,:arCreateTime,:arLocID,:arStatus,:medRecord,:medDiag,:HepatitisB,:OperRes,:FoundDate,:PisType,:PrevHis))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  更新病理主表
ClassMethod UpdPisMaster(PisID As %String, mListData As %String) As %String
{
	n (PisID, mListData)
	s ListData=$p(mListData,"&")
	s EmgFlag=$p(ListData,"^",6)     ///加急标志
	s FrostFlag=$p(ListData,"^",7)   ///冰冻标志
	s FoundDate=$p(ListData,"^",8)   ///人乳头病毒发现日期
	//s:FoundDate'="" FoundDate=$zdh(FoundDate,3)
	s:FoundDate'="" FoundDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(FoundDate)
	s medRecord=$p(ListData,"^",9)   ///临床病历
	s medDiag=$p(ListData,"^",10)    ///临床诊断
	s HepatitisB=$p(ListData,"^",11) ///乙肝病史
	s OperRes=$p(ListData,"^",12)    ///手术所见
	s PrevHis=$p(ListData,"^",15)    ///既往手术史 18-7-3
	s HisCodeID=""
	s arUserID=$p(ListData,"^",4)    ///申请医生
	s arStatus=$p(^DHCAPPPM(PisID),"^",9)
	s DoctorID=##class(web.SSUser).GetDefaultCareProvider(arUserID)
	s practiceFlag=##class(web.DHCOEOrdItem).practice(DoctorID)
	if (practiceFlag=1){
		s arStatus="I"	
	}else{
		if (arStatus="I"){s arStatus="N"}
		}
	b ;09323
	&SQL(Update DHC_AppPisMaster Set AP_FrostFlag=:FrostFlag,AP_EmgFlag=:EmgFlag,AP_MedRecord=:medRecord,AP_MedDiag=:medDiag,AP_Status=:arStatus,
		AP_HepatitisB=:HepatitisB,AP_OperRes=:OperRes,AP_PerPapVirus=:FoundDate,AP_Status_Dr=:HisCodeID,AP_DisHistory=:PrevHis Where AP_RowID=:PisID)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  插入医嘱表
ClassMethod InsPisArc(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&")
	s itmmastid=$p(ListData,"^",1)  /// 医嘱项ID
	s arLocID=$p(ListData,"^",2)    /// 接收科室ID
	s arOeori=$p(ListData,"^",14)   /// 医嘱ID
	s arChildSub=$o(^DHCAPPPM(arParref,"A",""),-1)+1

	&SQL(Insert Into DHC_AppPisArc(AP_ParRef_Dr,AP_ChildSub,AP_Arc_Dr,AP_Loc_Dr,AP_OrdItem)
		values(:arParref,:arChildSub,:itmmastid,:arLocID,:arOeori))
	Q SQLCODE
}

/// Descritp:  插入标本表
ClassMethod InsPisSpec(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s arFixActive=$p(mListData,"#",2) ///固定液
	s mListData=$p(mListData,"#",1) 
	
	s Len = $L(mListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  D
	.s ListData=$p(mListData,"@",i) /// 项目列表
	.s arNo=$p(ListData,"^",1)      /// 标本序号
	.s arID=$p(ListData,"^",2)      /// 标本标识
	.s arName=$p(ListData,"^",3)    /// 标本名字
	.Q:arName=""
	.s arPart=$p(ListData,"^",4)    /// 标本部位
	.s arQty=$p(ListData,"^",5)     /// 标本数量
	.s arSliType=$p(ListData,"^",6) /// 拨片/蜡片
	.s arPisNo=$p(ListData,"^",7)   /// 原病历号
	.s arRemark=$p(ListData,"^",8)  /// 备注
	.s arType=$p(ListData,"^",9)    /// 标本类型
	.s arChildSub=$o(^DHCAPPPM(arParref,"S",""),-1)+1
	.
	.&SQL(Insert Into DHC_AppPisSpec(AP_ParRef_Dr,AP_ChildSub,AP_NO,AP_ID,AP_Name,AP_PisNo,AP_Part,AP_Qty,AP_SliType,AP_Remark,AP_Type,AP_FixActive)
		values(:arParref,:arChildSub,:arNo,:arID,:arName,:arPisNo,:arPart,:arQty,:arSliType,:arRemark,:arType,:arFixActive))
	.i SQLCODE'=0 s quitflag="1"
	Q quitflag
}

/// Descritp:  插入取材信息表
ClassMethod InsPisCutBas(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s arSepDate=$p(mListData,"^",1)   /// 离体日期
	//s:arSepDate'="" arSepDate=$zdh(arSepDate,3)
	s:arSepDate'="" arSepDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arSepDate)
	s arSepTime=$p(mListData,"^",2)   /// 离体时间
	s:arSepTime'="" arSepTime=..%ZTH(arSepTime,1)
	s arFixDate=$p(mListData,"^",3)   /// 固定日期
	//s:arFixDate'="" arFixDate=$zdh(arFixDate,3)
	s:arFixDate'="" arFixDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arFixDate)
	s arFixTime=$p(mListData,"^",4)   /// 固定时间
	s:arFixTime'="" arFixTime=..%ZTH(arFixTime,1)
	s arLocID=$p(mListData,"^",5)     /// 取材科室
	s arDocDr=$p(mListData,"^",6)     /// 取材医生
	s arPosition=$p(mListData,"^",7)  /// 取材部位
	s arType=$p(mListData,"^",8)      /// 取材类型
	
	s arOperName=$p(mListData,"^",9)  /// 手术名称
	s arOperPart=$p(mListData,"^",10) /// 手术部位
	s arOperDate=$p(mListData,"^",11) /// 手术日期
	s:arOperDate'="" arOperDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arOperDate)
	s arOperTime=$p(mListData,"^",12) /// 手术时间
	s:arOperTime'="" arOperTime=..%ZTH(arOperTime,1)
	s arOperUser=$p(mListData,"^",13) /// 手术医生
	s arOperUTel=$p(mListData,"^",14) /// 联系电话
	s arOperRoom=$p(mListData,"^",15) /// 手术室/间
	S arOperAim=$p(mListData,"^",16)  /// 送检目的
	S arOperWay=$p(mListData,"^",17)  /// 手术方式	
	
	s arChildSub=$o(^DHCAPPPM(arParref,"B",""),-1)+1

	&SQL(Insert Into DHC_AppPisCutBas(AP_ParRef_Dr,AP_ChildSub,AP_SepDate,AP_SepTime,AP_FixDate,AP_FixTime,AP_Loc_Dr,AP_Doc_Dr,AP_Position,AP_Type,
		AP_OperName,AP_OperPart,AP_OperDate,AP_OperTime,AP_OperUser,AP_OperUserTel,AP_OperRoom,AP_OperWay,AP_OperAim)
		values(:arParref,:arChildSub,:arSepDate,:arSepTime,:arFixDate,:arFixTime,:arLocID,:arDocDr,:arPosition,:arType,:arOperName,:arOperPart,:arOperDate,
		:arOperTime,:arOperUser,:arOperUTel,:arOperRoom,:arOperWay,:arOperAim))

	Q SQLCODE
}

/// Descritp:  插入肿瘤表
ClassMethod InsPisTumour(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s arFoundDate=$p(mListData,"^",1)   /// 肿瘤发现日期
	//s:arFoundDate'="" arFoundDate=$zdh(arFoundDate,3)
	s:arFoundDate'="" arFoundDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arFoundDate)
	s arTumPart=$p(mListData,"^",2)     /// 肿瘤部位
	s arTumSize=$p(mListData,"^",3)     /// 肿瘤大小
	s arTransFlag=$p(mListData,"^",4)   /// 是否转移
	s arTransPos=$p(mListData,"^",5)    /// 转移部位
	s arRadCureFlag=$p(mListData,"^",6) /// 是否放疗
	s arCheCureFlag=$p(mListData,"^",7) /// 是否化疗
	s arRemark=$p(mListData,"^",8)      /// 其他信息
	s arChildSub=$o(^DHCAPPPM(arParref,"T",""),-1)+1

	&SQL(Insert Into DHC_AppPisTumour(AP_ParRef_Dr,AP_ChildSub,AP_FoundDate,AP_TumPart,AP_TumSize,AP_TransFlag,AP_TransPos,AP_RadCureFlag,AP_CheCureFlag,AP_Remark)
		values(:arParref,:arChildSub,:arFoundDate,:arTumPart,:arTumSize,:arTransFlag,:arTransPos,:arRadCureFlag,:arCheCureFlag,:arRemark))
	Q SQLCODE
}

/// Descritp:  插入妇科信息表
ClassMethod InsPisGynWon(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s arLastMensDate=$p(mListData,"^",1)   /// 上次月经
	//s:arLastMensDate'="" arLastMensDate=$zdh(arLastMensDate,3)
	s:arLastMensDate'="" arLastMensDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arLastMensDate)
	s arMensDate=$p(mListData,"^",2)       /// 末次月经
	//s:arMensDate'="" arMensDate=$zdh(arMensDate,3)
	s:arMensDate'="" arMensDate=##Class(web.DHCAPPCommonUtil).DateHtmlToLogical(arMensDate)
	s arPreTimes=$p(mListData,"^",3)       /// 怀孕次数
	s arLyTimes=$p(mListData,"^",4)        /// 生产次数
	s arPauFlag=$p(mListData,"^",5)        /// 是否绝经
	s arUnknownFlag=$p(mListData,"^",6)        /// 是否不详
	s arBloodFlag=$p(mListData,"^",7)        /// 是否子宫异常出血
	
	s arChildSub=$o(^DHCAPPPM(arParref,"G",""),-1)+1

	&SQL(Insert Into DHC_AppPisGynWon(AP_ParRef_Dr,AP_ChildSub,AP_LastMensDate,AP_MensDate,AP_PauFlag,AP_PreTimes,AP_LyTimes,AP_AbnBleed,AP_MenUnknown)
		values(:arParref,:arChildSub,:arLastMensDate,:arMensDate,:arPauFlag,:arPreTimes,:arLyTimes,:arBloodFlag,:arUnknownFlag))
	Q SQLCODE
}

/// Descritp:  插入尸检表
ClassMethod InsPisAutoPsy(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&",2)
	s arMorToDeaPro=$p(ListData,"^",1)   /// 自发病至死亡病程时日
	s arDisAndTrePro=$p(ListData,"^",2)  /// 病史及治疗过程
	s arPhyAndLabTest=$p(ListData,"^",3) /// 临床体格检查及化验检查
	s arCorTrePro=$p(ListData,"^",4)     /// 解剖后尸体之处理
	s arChildSub=$o(^DHCAPPPM(arParref,"AP",""),-1)+1

	&SQL(Insert Into DHC_AppPisAutoPsy(AP_ParRef_Dr,AP_ChildSub,AP_MorToDeaPro,AP_DisAndTrePro,AP_PhyAndLabTest,AP_CorTrePro)
		values(:arParref,:arChildSub,:arMorToDeaPro,:arDisAndTrePro,:arPhyAndLabTest,:arCorTrePro))
	Q SQLCODE
}

/// Descritp:  插入会诊扩展表
ClassMethod InsPisConsult(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&",2)
	s arInsDoc=$p(ListData,"^",1)     /// 送检医生
	s arInsHosp=$p(ListData,"^",2)    /// 送检医院
	s arSpecExaRes=$p(ListData,"^",3) /// 大体标本检查所见
	s arConsNote=$p(ListData,"^",4)   /// 会诊要求
	s arConsStaff=$p(ListData,"^",5)  /// 会诊专家
	s arChildSub=$o(^DHCAPPPM(arParref,"C",""),-1)+1

	&SQL(Insert Into DHC_AppPisConsult(AP_ParRef_Dr,AP_ChildSub,AP_InsDoc,AP_InsHosp,AP_SpecExaRes,AP_ConsNote,AP_ConsStaff)
		values(:arParref,:arChildSub,:arInsDoc,:arInsHosp,:arSpecExaRes,:arConsNote,:arConsStaff))
	Q SQLCODE
}

/// Descritp:  插入病人病历表
ClassMethod InsPisPatRec(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(mListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 病历ID
	.s itemDesc=$p(itmData,"^",2)      /// 病历描述
	.
	.&SQL(Insert Into DHC_AppPisPatRec(AP_PisMas_Dr,AP_Rec_Dr,AP_RecDesc)values(:arParref,:itemid,:itemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descritp:  插入检测方法
ClassMethod InsPisTesMet(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&",2)
	s Len = $L(ListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(ListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 检测方法ID
	.s itemDesc=$p(itmData,"^",2)      /// 检测方法描述
	.
	.&SQL(Insert Into DHC_AppPisTesMet(AP_PisMas_Dr,AP_TesItm_Dr,AP_TesItmDesc)values(:arParref,:itemid,:itemDesc))
	.i SQLCODE'=0 s quitflag="1"
	.
	Q quitflag
}

/// Descritp:  插入临床诊断
ClassMethod InsPisTesDiag(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&",3)
	s Len = $L(ListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(ListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 诊断ID
	.s itemDesc=$p(itmData,"^",2)      /// 诊断描述
	.
	.&SQL(Insert Into DHC_AppPisTesDiag(AP_PisMas_Dr,AP_TesDiag_Dr,AP_TesDiagDesc)values(:arParref,:itemid,:itemDesc))
	.i SQLCODE'=0 s quitflag="1"
	.
	Q quitflag
}

/// Descritp:  插入治疗方式
ClassMethod InsPisTreatMet(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s ListData=$p(mListData,"&",4)
	s Len = $L(ListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(ListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 治疗方式ID
	.s itemDesc=$p(itmData,"^",2)      /// 治疗方式描述
	.
	.&SQL(Insert Into DHC_AppPisTreMet(AP_PisMas_Dr,AP_TreMet_Dr,AP_TreMetDesc)values(:arParref,:itemid,:itemDesc))
	.i SQLCODE'=0 s quitflag="1"
	.
	Q quitflag
}

/// Descritp:  插入检测项目
ClassMethod InsPisTesItm(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(mListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 检测方法ID
	.
	.&SQL(Insert Into DHC_AppPisTesItm(AP_PisMas_Dr,AP_TesItm_Dr)values(:arParref,:itemid))
	.i SQLCODE'=0 s quitflag="1"
	.
	Q quitflag
}

/// Descritp:  检测方法绑定医嘱
ClassMethod InsPisTesItmArc(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s LocID=$p(mListData,"^",5)        ///申请科室
	s ListData=$p(mListData,"&",3)
	s Len = $L(ListData,"@")
	s Err=0
	f i=1:1:Len q:Err'="0"  d
	.s itemid=$p(ListData,"@",i)      /// 检测方法ID
	.Q:+itemid=0
	.s itmmastid=$p(^DHCAPPTI(itemid),"^",3)
	.Q:+itmmastid=0
	.s Err=..InsPisArc(arParref,itmmastid_"^"_LocID)
	.
	Q Err
}

/// Descritp:  插入传染病史
ClassMethod InsPisPatInfDis(arParref As %String, mListData As %String) As %String
{
	n (arParref, mListData)
	s Len = $L(mListData,"@")
	s quitflag=0
	f i=1:1:Len q:quitflag'="0"  d
	.s itmData=$p(mListData,"@",i)     /// 项目列表
	.s itemid=$p(itmData,"^",1)        /// 病历ID
	.s itemDesc=$p(itmData,"^",2)      /// 病历描述
	.
	.&SQL(Insert Into DHC_AppPisInfDis(AP_PisMas_Dr,AP_InfDis_Dr,AP_InfDisDesc)values(:arParref,:itemid,:itemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript: 删除病理申请子表和关联表数据
/// w ##Class(web.DHCAppPisMaster).DelPisMasSubTable("24")
ClassMethod DelPisMasSubTable(PisID) As %String
{
	n (PisID)
	s SQLCODE=0

	/// 病理申请医嘱项   此表不删除！！！
	//i $o(^DHCAPPPM(PisID,"A","")) D
	//.&SQL(delete from DHC_AppPisArc where AP_ParRef_Dr=:PisID)
	//Q:SQLCODE'=0 SQLCODE
	
	
	/// 病理申请标本
	i $o(^DHCAPPPM(PisID,"S","")) D
	.&SQL(delete from DHC_AppPisSpec where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请取材
	i $o(^DHCAPPPM(PisID,"B","")) D
	.&SQL(delete from DHC_AppPisCutBas where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE

	/// 病理申请肿瘤
	i $o(^DHCAPPPM(PisID,"T","")) D
	.&SQL(delete from DHC_AppPisTumour where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请妇科
	i $o(^DHCAPPPM(PisID,"G","")) D
	.&SQL(delete from DHC_AppPisGynWon where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请尸检
	i $o(^DHCAPPPM(PisID,"AP","")) D
	.&SQL(delete from DHC_AppPisAutoPsy where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE

	/// 病理申请会诊
	i $o(^DHCAPPPM(PisID,"C","")) D
	.&SQL(delete from DHC_AppPisConsult where AP_ParRef_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE

	/// 病理申请病人病历
	i $o(^DHCAPPPPR(0,"PisMas",PisID,"")) D
	.&SQL(delete from DHC_AppPisPatRec where AP_PisMas_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请检测方法
	i $o(^DHCAPPPTIM(0,"PisMas",PisID,"")) D
	.&SQL(delete from DHC_AppPisTesMet where AP_PisMas_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请临床诊断
	i $o(^DHCAPPPTD(0,"PisMas",PisID,"")) D
	.&SQL(delete from DHC_AppPisTesDiag where AP_PisMas_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请治疗方式
	i $o(^DHCAPPPTM(0,"PisMas",PisID,"")) D
	.&SQL(delete from DHC_AppPisTreMet where AP_PisMas_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请传染病史
	i $o(^DHCAPPPID(0,"PisMas",PisID,"")) D
	.&SQL(delete from DHC_AppPisInfDis where AP_PisMas_Dr=:PisID)
	Q:SQLCODE'=0 SQLCODE
	
	/// 病理申请检测项目   此表不删除！！！
	//i $o(^DHCAPPPTI(0,"PisMas",PisID,"")) D
	//.&SQL(delete from DHC_AppPisTesItm where AP_PisMas_Dr=:PisID)
	//Q:SQLCODE'=0 SQLCODE
	Q 0
}

/// Descript: 取病理申请数据
/// w ##Class(web.DHCAppPisMaster).JsGetPisNoObj("394")
ClassMethod JsGetPisNoObj(PisID) As %String
{
	n (PisID)
	Q:'$D(^DHCAPPPM(PisID)) ""
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)   /// 就诊ID
	s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)   /// 冰冻标志
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急标志
	s No=$p(^DHCAPPPM(PisID),"^",4)          /// 申请单号
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s MedRecord=$p(^DHCAPPPM(PisID),"^",14)  /// 临床病历
	s MedDiag=$p(^DHCAPPPM(PisID),"^",15)    /// 临床诊断
	s HepatitisB=$p(^DHCAPPPM(PisID),"^",16) /// 乙肝病史
	s OperRes=$p(^DHCAPPPM(PisID),"^",17)    /// 手术所见
	s PrevHis=$p(^DHCAPPPM(PisID),"^",24)	 /// 既往手术史 18-7-3
	s InfDisHis=$p(^DHCAPPPM(PisID),"^",18)  /// 传染病史
	s FoundDate=$p(^DHCAPPPM(PisID),"^",19)  /// 首次发现人乳头瘤病毒时间
	s:FoundDate'="" FoundDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(FoundDate)
	s ApplyDocDesc=""
	s ApplyDocId=$p(^DHCAPPPM(PisID),"^",5)	 /// 申请医生(UserID)
	s:ApplyDocId'="" ApplyDocDesc=$p(^SSU("SSUSR",ApplyDocId),"^",2) 
	s ApplyLocId=$p(^DHCAPPPM(PisID),"^",8)	 /// 申请科室
	s:ApplyLocId'="" ApplyLocDesc=$p(^CTLOC(ApplyLocId),"^",2)
	s SendPisFlag=##Class(web.DHCAppPisMasterQuery).GetSendPisFlag(PisID)
	s apStatus=$p(^DHCAPPPM(PisID),"^",9)	
	i apStatus="I" s SendPisFlag=3
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID) /// 病理申请医嘱项目内容
	s ItemDesc=$p(PisArcList,"^"),LocID=$p(PisArcList,"^",2),LocDesc=$p(PisArcList,"^",3),arcimid=$p(PisArcList,"^",4),Oeori=$p(PisArcList,"^",5)

	s PisAutoPsy=##Class(web.DHCAppPisMaster).GetPisAutoPsy(PisID) /// 病理申请尸检信息内容
	s MorToDeaPro=$p(PisAutoPsy,"^"),DisAndTrePro=$p(PisAutoPsy,"^",2),PhyAndLabTest=$p(PisAutoPsy,"^",3),FinTakRes=$p(PisAutoPsy,"^",4)

	s PisConsult=##Class(web.DHCAppPisMaster).GetPisConsult(PisID) /// 病理申请会诊信息内容
	s InsDoc=$p(PisConsult,"^"),InsHosp=$p(PisConsult,"^",2),SpecExaRes=$p(PisConsult,"^",3),ConsNote=$p(PisConsult,"^",4),ConsStaff=$p(PisConsult,"^",5)

	s PisGynWon=##Class(web.DHCAppPisMaster).GetPisGynWon(PisID)  /// 病理申请妇科信息内容
	s LastMensDate=$p(PisGynWon,"^"),MensDate=$p(PisGynWon,"^",2),PreTimes=$p(PisGynWon,"^",3),LyTimes=$p(PisGynWon,"^",4),PauFlag=$p(PisGynWon,"^",5)
	s UnknownFlag=$p(PisGynWon,"^",6),BloodFlag=$p(PisGynWon,"^",7)
	
	s PisCutBas=##Class(web.DHCAppPisMaster).GetPisCutBas(PisID)  /// 病理申请取材信息内容
	s SepDate=$p(PisCutBas,"^"),SepTime=$p(PisCutBas,"^",2),FixDate=$p(PisCutBas,"^",3),FixTime=$p(PisCutBas,"^",4),BLocDesc=$p(PisCutBas,"^",5)	
	s DocName=$p(PisCutBas,"^",6),BLocID=$p(PisCutBas,"^",9),BDocID=$p(PisCutBas,"^",10),OperName=$p(PisCutBas,"^",11),OperPart=$p(PisCutBas,"^",12)
	s OperDate=$p(PisCutBas,"^",13),OperTime=$p(PisCutBas,"^",14),OperUser=$p(PisCutBas,"^",15),OperUTel=$p(PisCutBas,"^",16),OperRoom=$p(PisCutBas,"^",17)
	s arOperUserName=$p(PisCutBas,"^",18),OperWay=$p(PisCutBas,"^",19),OperAim=$p(PisCutBas,"^",20)
	
	s SepDate=SepDate_" "_SepTime i +SepDate=0 s SepDate=""
	s FixDate=FixDate_" "_FixTime i +FixDate=0 s FixDate=""
	s OperDate=OperDate_" "_OperTime i +OperDate=0 s OperDate=""
	
	s PisTumour=##Class(web.DHCAppPisMaster).GetPisTumour(PisID)  /// 病理申请肿瘤信息内容
	s TFoundDate=$p(PisTumour,"^"),TumPart=$p(PisTumour,"^",2),TumSize=$p(PisTumour,"^",3),TransFlag=$p(PisTumour,"^",4),TransPos=$p(PisTumour,"^",5)	
	s RadCureFlag=$p(PisTumour,"^",6),CheCureFlag=$p(PisTumour,"^",7),Remark=$p(PisTumour,"^",8)
	
	s PisSpec=##Class(web.DHCAppPisMasterQuery).GetPisSpec(PisID)  /// 病理申请标本信息内容(分子病理用)
	s Position=$p(PisSpec,"^",1),Type=$p(PisSpec,"^",2)
	
    s ListData=EpisodeID_"^"_FrostFlag_"^"_EmgFlag_"^"_No_"^"_PisNo_"^"_MedRecord_"^"_MedDiag_"^"_HepatitisB_"^"_OperRes_"^"_InfDisHis
    s ListData=ListData_"^"_FoundDate_"^"_arcimid_"^"_Oeori_"^"_ItemDesc_"^"_LocID_"^"_LocDesc_"^"_MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_FinTakRes
    s ListData=ListData_"^"_InsDoc_"^"_InsHosp_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff_"^"_LastMensDate_"^"_MensDate_"^"_PreTimes
    s ListData=ListData_"^"_LyTimes_"^"_PauFlag_"^"_SepDate_"^"_FixDate_"^"_BLocDesc_"^"_DocName_"^"_Position_"^"_Type
    s ListData=ListData_"^"_TFoundDate_"^"_TumPart_"^"_TumSize_"^"_TransFlag_"^"_TransPos_"^"_RadCureFlag_"^"_CheCureFlag_"^"_Remark_"^"_SendPisFlag
    s ListData=ListData_"^"_BLocID_"^"_BDocID_"^"_ApplyDocId_"^"_ApplyDocDesc_"^"_ApplyLocId_"^"_ApplyLocDesc_"^"_OperName_"^"_OperPart_"^"_OperDate_"^"_OperUser_"^"_OperUTel_"^"_OperRoom_"^"_arOperUserName
	s ListData=ListData_"^"_OperWay_"^"_OperAim_"^"_PrevHis_"^"_UnknownFlag_"^"_BloodFlag
	
	s ListTitle="EpisodeID^FrostFlag^EmgFlag^No^PisNo^MedRecord^MedDiag^HepatitisB^OperRes^InfDisHis^FoundDate^arcimid^Oeori^ItemDesc^LocID^LocDesc^MorToDeaPro^DisAndTrePro^PhyAndLabTest^FinTakRes^InsDoc"
	s ListTitle=ListTitle_"^InsHosp^SpecExaRes^ConsNote^ConsStaff^LastMensDate^MensDate^PreTimes^LyTimes^PauFlag^SepDate^FixDate^BLocDesc^DocName^Position^Type"
	s ListTitle=ListTitle_"^TFoundDate^TumPart^TumSize^TransFlag^TransPos^RadCureFlag^CheCureFlag^Remark^SendPisFlag^BLocID^BDocID^ApplyDocId^ApplyDocDesc^ApplyLocId^ApplyLocDesc"
	s ListTitle=ListTitle_"^OperName^OperPart^OperDate^OperUser^OperUTel^OperRoom^arOperUserName^OperWay^OperAim^PrevHis^UnknownFlag^BloodFlag"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript: 取病理申请医嘱数据
/// w ##Class(web.DHCAppPisMaster).GetPisArc("")
ClassMethod GetPisArc(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"A",""))
	Q:CH="" ""
	s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)   /// 医嘱项ID
	s LocID=$p(^DHCAPPPM(PisID,"A",CH),"^",2)     /// 接收科室ID
	s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)     /// 医嘱ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s ItemDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	s LocDesc=""
	i LocID'="" s LocDesc=$p(^CTLOC(LocID),"^",2)
	Q ItemDesc_"^"_LocID_"^"_LocDesc_"^"_arcimid_"^"_Oeori
}

/// Descript: 取HPV申请治疗方式数据
/// w ##Class(web.DHCAppPisMaster).GetPisTreMet("")
ClassMethod GetPisTreMet(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTM(ID),"^",1)
	.s TreMetDesc=$p(^DHCAPPPTM(ID),"^",2)
	.i mData="" s mData=TreMetID_"^"_TreMetDesc
	.E  s mData=mData_"@"_TreMetID_"^"_TreMetDesc
	Q mData
}

/// Descript: 取HPV申请检测方法数据
/// w ##Class(web.DHCAppPisMaster).GetPisTesItmMet("")
ClassMethod GetPisTesItmMet(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTIM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTIM(ID),"^",1)
	.s TreMetDesc=$p(^DHCAPPPTIM(ID),"^",2)
	.i mData="" s mData=TreMetID_"^"_TreMetDesc
	.E  s mData=mData_"@"_TreMetID_"^"_TreMetDesc
	Q mData
}

/// Descript: 取HPV申请临床诊断数据
/// w ##Class(web.DHCAppPisMaster).GetPisTesDiag("")
ClassMethod GetPisTesDiag(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTD(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTD(ID),"^",1)
	.s TreMetDesc=$p(^DHCAPPPTD(ID),"^",2)
	.i mData="" s mData=TreMetID_"^"_TreMetDesc
	.E  s mData=mData_"@"_TreMetID_"^"_TreMetDesc
	Q mData
}

/// Descript: 取HPV申请病人病历数据
/// w ##Class(web.DHCAppPisMaster).GetPisPatRec("")
ClassMethod GetPisPatRec(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPPR(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPPR(ID),"^",1)
	.s TreMetDesc=$p(^DHCAPPPPR(ID),"^",2)
	.i mData="" s mData=TreMetID_"^"_TreMetDesc
	.E  s mData=mData_"@"_TreMetID_"^"_TreMetDesc
	Q mData
}

/// Descript: 取尸检申请单数据
/// w ##Class(web.DHCAppPisMaster).GetPisAutoPsy("")
ClassMethod GetPisAutoPsy(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"AP",""))
	Q:CH="" ""
	s MorToDeaPro=$p(^DHCAPPPM(PisID,"AP",CH),"^",1)    /// 自发病至死亡病程时日
	s DisAndTrePro=$p(^DHCAPPPM(PisID,"AP",CH),"^",2)   /// 病史及治疗过程
	s PhyAndLabTest=$p(^DHCAPPPM(PisID,"AP",CH),"^",3)  /// 临床体格检查及化验检查
	s CorTrePro=$p(^DHCAPPPM(PisID,"AP",CH),"^",4)      /// 解刨及处理方式 
	s:CorTrePro'="" CorTrePro=$s(CorTrePro=1:"TakBack",CorTrePro=2:"TakHosp",1:"")
	Q MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_CorTrePro
}

/// Descript: 取会诊申请单数据
/// w ##Class(web.DHCAppPisMaster).GetPisConsult("")
ClassMethod GetPisConsult(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"C",""))
	Q:CH="" ""
	s InsDoc=$p(^DHCAPPPM(PisID,"C",CH),"^",1)     /// 送检医生
	s InsHosp=$p(^DHCAPPPM(PisID,"C",CH),"^",2)    /// 送检医院
	s SpecExaRes=$p(^DHCAPPPM(PisID,"C",CH),"^",3) /// 大体标本检查所见
	s ConsNote=$p(^DHCAPPPM(PisID,"C",CH),"^",4)   /// 会诊要求
	s ConsStaff=$p(^DHCAPPPM(PisID,"C",CH),"^",5)  /// 会诊专家
	Q InsDoc_"^"_InsHosp_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff
}

/// Descript: 取妇科申请数据
/// w ##Class(web.DHCAppPisMaster).GetPisGynWon("")
ClassMethod GetPisGynWon(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"G",""))
	Q:CH="" ""
	s LastMensDate=$p(^DHCAPPPM(PisID,"G",CH),"^",1) /// 上次月经日期
	//s:LastMensDate'="" LastMensDate=$zd(LastMensDate,3)
	s:LastMensDate'="" LastMensDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(LastMensDate)
	s MensDate=$p(^DHCAPPPM(PisID,"G",CH),"^",2)     /// 末次月经日期
	//s:MensDate'="" MensDate=$zd(MensDate,3)
	s:MensDate'="" MensDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(MensDate)
	s PauFlag=$p(^DHCAPPPM(PisID,"G",CH),"^",3)      /// 是否绝经
	s PreTimes=$p(^DHCAPPPM(PisID,"G",CH),"^",4)     /// 怀孕次数
	s LyTimes=$p(^DHCAPPPM(PisID,"G",CH),"^",5)      /// 生产次数
	s APMenUnknown=$p(^DHCAPPPM(PisID,"G",CH),"^",14)      /// 不详
	s APAbnBleed=$p(^DHCAPPPM(PisID,"G",CH),"^",15)      /// 子宫异常出血
	
	Q LastMensDate_"^"_MensDate_"^"_PreTimes_"^"_LyTimes_"^"_PauFlag_"^"_APMenUnknown_"^"_APAbnBleed
}

/// Descript: 取材申请数据
/// w ##Class(web.DHCAppPisMaster).GetPisCutBas("")
ClassMethod GetPisCutBas(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"B",""))
	Q:CH="" ""
	s SepDate=$p(^DHCAPPPM(PisID,"B",CH),"^",1)  /// 取材离体日期
	s:SepDate'="" SepDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(SepDate)
	s SepTime=$p(^DHCAPPPM(PisID,"B",CH),"^",2)  /// 取材离体时间
	s:SepTime'="" SepTime=..%ZT(SepTime,1)
	s FixDate=$p(^DHCAPPPM(PisID,"B",CH),"^",3)  /// 开始固定日期
	s:FixDate'="" FixDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(FixDate)
	s FixTime=$p(^DHCAPPPM(PisID,"B",CH),"^",4)  /// 开始固定时间
	s:FixTime'="" FixTime=..%ZT(FixTime,1)
	//s LocDesc=$p(^DHCAPPPM(PisID,"B",CH),"^",5)  
	s LocID=$p(^DHCAPPPM(PisID,"B",CH),"^",5) 	 /// 取材科室
	i +LocID'=0 s LocDesc=$p(^CTLOC(LocID),"^",2)  /// 取材科室和医生改为下拉框选择 qunianpeng 2018/2/2
	//s DocName=$p(^DHCAPPPM(PisID,"B",CH),"^",6)  	
	s DocID=$p(^DHCAPPPM(PisID,"B",CH),"^",6)     /// 取材医生	
	i +DocID'=0 s DocName=$p(^SSU("SSUSR",DocID),"^",2)
	s Position=$p(^DHCAPPPM(PisID,"B",CH),"^",7) /// 取材部位
	s Type=$p(^DHCAPPPM(PisID,"B",CH),"^",8)     /// 取材类型
	
	s arOperName=$p(^DHCAPPPM(PisID,"B",CH),"^",9)  /// 手术名称
	s arOperPart=$p(^DHCAPPPM(PisID,"B",CH),"^",10) /// 手术部位
	s arOperDate=$p(^DHCAPPPM(PisID,"B",CH),"^",11) /// 手术日期
	s:arOperDate'="" arOperDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(arOperDate)
	s arOperTime=$p(^DHCAPPPM(PisID,"B",CH),"^",12) /// 手术时间
	s:arOperTime'="" arOperTime=..%ZT(arOperTime,1)
	s arOperUser=$p(^DHCAPPPM(PisID,"B",CH),"^",13) /// 手术医生
	s arOperUTel=$p(^DHCAPPPM(PisID,"B",CH),"^",14) /// 联系电话
	s arOperRoom=$p(^DHCAPPPM(PisID,"B",CH),"^",15) /// 手术室/间
	i +arOperUser'=0 s arOperUserName=$p(^SSU("SSUSR",arOperUser),"^",2)	/// qunianpeng 2018/8/29
	s arOperWay=$p(^DHCAPPPM(PisID,"B",CH),"^",16)  /// 手术方式 qunianpeng 2018/9/3
	s arOperAim=$p(^DHCAPPPM(PisID,"B",CH),"^",17)	/// 送检目的
	
	s ListDate=SepDate_"^"_SepTime_"^"_FixDate_"^"_FixTime_"^"_$g(LocDesc)_"^"_$g(DocName)_"^"_Position_"^"_Type_"^"_LocID_"^"_DocID
	s ListDate=ListDate_"^"_arOperName_"^"_arOperPart_"^"_arOperDate_"^"_arOperTime_"^"_arOperUser_"^"_arOperUTel_"^"_arOperRoom_"^"_$g(arOperUserName)_"^"_arOperWay_"^"_arOperAim
	Q ListDate
}

/// Descript: 取肿瘤数据
/// w ##Class(web.DHCAppPisMaster).GetPisTumour("")
ClassMethod GetPisTumour(PisID As %String) As %String
{
	n (PisID)
	s CH=$o(^DHCAPPPM(PisID,"T",""))
	Q:CH="" ""
	s FoundDate=$p(^DHCAPPPM(PisID,"T",CH),"^",1)   /// 肿瘤发现日期
	//s:FoundDate'="" FoundDate=$zd(FoundDate,3)
	s:FoundDate'="" FoundDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(FoundDate)
	s TumPart=$p(^DHCAPPPM(PisID,"T",CH),"^",2)     /// 肿瘤部位
	s TumSize=$p(^DHCAPPPM(PisID,"T",CH),"^",3)     /// 肿瘤大小
	s TransFlag=$p(^DHCAPPPM(PisID,"T",CH),"^",4)   /// 是否转移
	s TransPos=$p(^DHCAPPPM(PisID,"T",CH),"^",5)    /// 转移部位
	s RadCureFlag=$p(^DHCAPPPM(PisID,"T",CH),"^",6) /// 是否放疗
	s CheCureFlag=$p(^DHCAPPPM(PisID,"T",CH),"^",7) /// 是否化疗
	s Remark=$p(^DHCAPPPM(PisID,"T",CH),"^",8)      /// 其他信息
	Q FoundDate_"^"_TumPart_"^"_TumSize_"^"_TransFlag_"^"_TransPos_"^"_RadCureFlag_"^"_CheCureFlag_"^"_Remark
}

/// Descript: 病理申请插入医嘱
/// w ##Class(web.DHCAppPisMaster).InsPisOeori("61")
ClassMethod InsPisOeori(PisID As %String, BillTypeID As %String = "", InsurFlag As %String = "", ChronicDiagCode As %String = "", MasUserID As %String = "", ByRef ErrMsg As %String = "", EmConsultItm As %String = "") As %String
{
	n (PisID,BillTypeID,InsurFlag,ChronicDiagCode,%session,MasUserID,ErrMsg,EmConsultItm)
	
 	s IsCheckOrdItemStr="Y"
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)   /// 就诊ID
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s CFPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason","","",AdmHospitalId)
 	s CFIPPilotPatAdmReason=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason","","",AdmHospitalId)
 	if (BillTypeID=CFPilotPatAdmReason)||(BillTypeID=CFPilotPatAdmReason) s PPFlag="Y"
 	else  s PPFlag="N"
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急
	s UserID=$p(^DHCAPPPM(PisID),"^",5)      /// 用户ID
	s LocID=$p(^DHCAPPPM(PisID),"^",8)       /// 科室ID
	if MasUserID'="" s UserID=MasUserID
	s PisType=$p(^DHCAPPPM(PisID),"^",20) 
	if (PisType="APYN") s IsCheckOrdItemStr="N"
	/// 根据病理项目生成医嘱
	s Err=0, CH=""
	F  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:(CH="")||(Err'=0)  D
	.s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)  /// 医嘱项ID
	.s recLocID=$p(^DHCAPPPM(PisID,"A",CH),"^",2) /// 接收科室ID
	.s mOeori=""
	.i CH'=1 s mOeori=$p(^DHCAPPPM(PisID,"A",1),"^",3)
	.Q:$p(^DHCAPPPM(PisID,"A",CH),"^",3)'=""
	.s itmmaststr = arcimid_"^"_recLocID_"^"_EmConsultItm
	.s arReqArcID=""	;PisID_"||"_CH
	.s ErrMsg=""
	.s ret=##Class(web.DHCAPPExaReport).SaveOrderItems(EpisodeID,itmmaststr,UserID,LocID,EmgFlag,"",arReqArcID,"",mOeori,BillTypeID,PPFlag,InsurFlag,ChronicDiagCode,.ErrMsg,IsCheckOrdItemStr) /// 插入医嘱
	.i ret=100 s Err=-1
	.q:ret=100
	.s Oeori=$p(ret,"*",2)  /// 医嘱ID
	.s Err=..UpdPisArc(PisID_"||"_CH, Oeori)
	.
	Q:Err'=0 Err
	
	//
	s mOeori=""
	F  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:(CH="")||(Err'=0)  D
	.s mOeori=$p(^DHCAPPPM(PisID,"A",1),"^",3)
	;s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000042",mOeori)
	Q 0
}

/// Descript:  更新病理医嘱项目表医嘱id
ClassMethod UpdPisArc(arRowID As %String, arOeori As %String) As %String
{
	n (arRowID, arOeori)
	&SQL(update DHC_AppPisArc set AP_OrdItem=:arOeori where AP_RowID=:arRowID)
	s arReqArcID=$P($G(^OEORD(+arOeori,"I",$P(arOeori,"||",2),"DHC")),"^",42)
	if arReqArcID=""{
		&SQL(UPDATE OE_OrdItemExt SET OEORI_AppReport_DR=:arRowID WHERE OEORI_RowID=:arOeori)
	}
	Q SQLCODE
}

/// Descript: 撤销病理申请单
/// w ##Class(web.DHCAppPisMaster).revPisMain("63","4634")
ClassMethod revPisMain(PisID As %String, UserID As %String) As %String
{
	n (PisID, UserID,%session)
	Q:(PisID="")||(UserID="") "-1"
	Q:'$D(^DHCAPPPM(PisID)) "-2"
	s SendPisFlag=##Class(web.DHCAppPisMasterQuery).GetSendPisFlag(PisID)
	Q:SendPisFlag=1 "-3"
	TS
	/// 更新申请单状态
	s Err=..UpdPisMasStatus(PisID, UserID)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	/// 调用停医嘱接口
	s Err=..InvPisStopOrder(PisID, UserID)
	i Err'=0 tro
	s Err=..%GetErrCodeMsg(Err)
	TC
	/// 取消病理申请单，发送状态给Pis系统
	//D ##Class(web.DHCAPPPisInterface).CancelPisNo(PathID)
	Q Err
}

/// Descript: 更新申请单状态
/// w ##Class(web.DHCAppPisMaster).UpdPisMasStatus("61","")
ClassMethod UpdPisMasStatus(PisID As %String, UserID As %String) As %String
{
	n (PisID, UserID,%session)
	s ApStatus="D"
	s XDate=..%SysDate()   		///停止日期
	s XTime=..%SysTime()   		///停止时间
	&SQL(update DHC_AppPisMaster set AP_Status=:ApStatus, AP_XUser_Dr=:UserID, AP_XDate=:XDate, AP_XTime=:XTime 
		where AP_RowID=:PisID)
	Q SQLCODE
}

/// Descript:  调用停医嘱接口
/// W ##Class(web.DHCAppPisMaster).InvPisStopOrder("85722||1","13")
ClassMethod InvPisStopOrder(PisID As %String, LgUserID As %String) As %String
{
	n (PisID, LgUserID,%session)
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)	    /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)  		/// 病人类型
	s Err=0
	s ErrMsg=""
	s CH=""
	F  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:(CH="")||(Err'=0)  D
	.s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)                        /// 医嘱ID
	.s ordStatus=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.s:ordStatus="E" Err=-12
	.Q:ordStatus'="V"     /// 医嘱状态
	.i PatType="I" D
	..s Err=##class(appcom.OEOrdItem).CancelMulti(Oeori,LgUserID,"","N") /// 住院撤销医嘱
	.E  D
	..s Err=##Class(appcom.OEOrdItem).StopMulti(Oeori,LgUserID,"","N","",.ErrMsg)   /// 门诊停止医嘱
	..if Err'=0 s Err=Err_ErrMsg
	Q Err
}

/// Descript:  发送病理申请单
/// W ##Class(web.DHCAppPisMaster).InsSendFlag("404")
ClassMethod InsSendFlag(PisID As %String, UserID As %String, BillTypeID As %String = "", InsurFlag As %String = "") As %String
{
	n (PisID,UserID,BillTypeID,InsurFlag,%session)
	s:$d(%session) UserID = %session.Data("LOGON.USERID")
	s Err=0
	/// 申请状态
	Q:$p(^DHCAPPPM(PisID),"^",9)="Y" "-1" 
	TS

	/// 插入医嘱
	s Err = ..UpdPisSendFlag(PisID)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 插入医嘱
	s Err = ..InsPisOeori(PisID,BillTypeID,InsurFlag)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	TC
	//插入医嘱成功后会自动发送
	//d ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",PisID,UserID)
	
	Q Err
}

/// Descript:  更新病理申请单发送状态
/// W ##Class(web.DHCAppPisMaster).UpdPisSendFlag("85722||1","13")
ClassMethod UpdPisSendFlag(PisID As %String) As %String
{
	n (PisID)
	s ApStatus="Y"
	&SQL(update DHC_AppPisMaster set AP_Status=:ApStatus where AP_RowID=:PisID)
	Q SQLCODE
}

/// Descript:   取当前不良反应报告最大码
ClassMethod GetCurMaxNo(Prefix As %String, NoLen As %String) As %String
{
	N (Prefix,NoLen)
	S NextNo=""
	s Suffix=$I(^DHCAPPPIS("DHCPHCMADR",Prefix))
	S slen=$L(Suffix)
	S flen=NoLen-slen
	F i=1:1:flen S Suffix="0"_Suffix
	S NextNo=Prefix_Suffix
	q NextNo
}

/// Descript:获取当前最大码
/// 科室当前处方最编码
ClassMethod GetMaxCodeByCode(Prefix As %String) As %String
{
	N (Prefix)
	Q:Prefix="" ""
	S adrrcode=""
	//&sql(select max(AP_No) into :adrrcode from DHC_AppPisMaster Where AP_No %STARTSWITH %ALPHAUP :Prefix)
	S PreLen=$L(Prefix)
	s ARRowID=""
	for{
		s ARRowID=$O(^DHCAPPPM(0,"CreateDate",+$H,ARRowID))
		q:ARRowID=""
		s MaxNo=$P(^DHCAPPPM(ARRowID),"^",4)
		continue:MaxNo'[Prefix
		if $E(MaxNo,PreLen+1,$l(MaxNo))>$E(adrrcode,PreLen+1,$l(adrrcode)) s adrrcode=MaxNo
	}
	Q adrrcode
}

/// Descritp:  临时保存病理申请内容
/// Input:     PisType-申请类型(病理申请单类别)，mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsExaTempDoc("1","","")
ClassMethod InsExaTempDoc(Pid As %String, mListData As %String, mPatSymData As %String) As %String
{
	n (Pid, mListData, mPatSymData)
	s ^TMP("DHCAPP","web.DHCAppPisMaster",Pid,"EXA",1)=mListData_$C(3)_mPatSymData //$C(2)
	Q 0
}

/// Descritp:  临时保存病理申请内容
/// Input:     PisType-申请类型(病理申请单类别)，mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertTempDoc("1","","")
ClassMethod InsertTempDoc(Pid As %String, mListData As %String, mItemParam As %String) As %String
{
	n (Pid, mListData, mItemParam)
	s ^BIANSHUAI(123)=Pid_","_mListData_","_mItemParam
	s PisType=$p(mListData,"^",13)   /// 申请单类型
	F i=1:1:$L(mItemParam,"@")  D
	.s mItemArr=$p(mItemParam,"@",i)
	.s $p(mListData,"^",1)=$p(mItemArr,"^",4)  /// 医嘱项
	.s $p(mListData,"^",2)=$p(mItemArr,"^",2)  /// 接收科室
	.s FrostFlag=##Class(web.DHCAppPisMasterQuery).GetItmFrostFlag($p(mItemArr,"^",4))
	.s $p(mListData,"^",7)=FrostFlag
	.s ^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType,i)=PisType_"###"_mListData_"###"_mItemArr
	Q 0
}

/// Descritp:  插入病理申请内容
/// Input:     PisType-申请类型(病理申请单类别)，mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).InsertDoc("1")
ClassMethod InsertDoc(Pid As %String) As %String
{
	n (Pid)
	m ^tempscl("InsertDoc")=^TMP("DHCAPP","web.DHCAppPisMaster",Pid)
	s PisType="",Err=0,mdata=""
	F  s PisType=$o(^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType)) Q:(PisType="")||(Err'=0)  D
	.s index=""
	.F  s index=$o(^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType,index)) Q:(index="")||(Err'=0)  D
	..s mItem=$g(^TMP("DHCAPP","web.DHCAppPisMaster",Pid,PisType,index))
	..i PisType="EXA" D
	...s res=..InsExaReqNo(Pid, mItem)
	..E  D
	...s res=..InsPisMasNo(PisType, mItem)
	..s mdata=$s(mdata'="":mdata_"@"_res,1:res)  ///申请表ID串
	.
	k ^TMP("DHCAPP","web.DHCAppPisMaster",Pid)
	Q mdata
}

/// Descritp:  插入检查申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单子表ID^医嘱项ID^唯一标识
/// w ##Class(web.DHCAppPisMaster).InsertDoc("1")
ClassMethod InsExaReqNo(Pid As %String, ListData As %String) As %String
{
	n (Pid, ListData)
	s mPatSymData=$p(ListData,$C(3),2),ListData=$p(ListData,$C(3),1) //$C(2)
	s res=##Class(web.DHCAPPExaReport).saveDoc(Pid, ListData, mPatSymData)
	Q res
}

/// Descritp:  插入病理申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单子表ID^医嘱项ID^唯一标识
/// w ##Class(web.DHCAppPisMaster).InsertDoc("1")
ClassMethod InsPisMasNo(PisType As %String, ListData As %String) As %String
{
	n (PisType, ListData)
	/*s mListData=$p(ListData,"###",2)   /// 申请单内容
	s mItemParam=$p(ListData,"###",3)  /// 申请单项目
	s itmmastid=$p(mItemParam,"^",4)   /// 医嘱项
	s uniqueID=$p(mItemParam,"^",5)    /// 唯一标示
	s PisID=..Insert(PisType, "", mListData)
	Q:PisID<0 PisID*/
	s EpisodeID=$P(ListData,$C(1),1)
	s DocID=$P(ListData,$C(1),2)
	s LocID=$P(ListData,$C(1),3)
	s Type=$P(ListData,$C(1),4)
	s OEOrdStr=$P(ListData,$C(1),5)
	s JsonStr=$P(ListData,$C(1),6)
	s itmmastid=$P(OEOrdStr,"^",1)
	s uniqueID=$P(ListData,$C(1),7)
	s PisID=##class(web.DHCDocAPPBL).InsertNewBLInformation(EpisodeID, DocID, LocID, Type, OEOrdStr, JsonStr, "","","",1)
	if ($P(PisID,"^",1)'=0) q $P(PisID,"^",1)
	s res=$P(PisID,"^",2)_"||"_1_"^"_itmmastid_"^"_uniqueID
	Q res
}

/// Descritp:  判断是否发送申请单
/// Input:     申请单子表ID
/// Ouput:     1 发送 0 未发送 2 未保存 3 已取消申请
/// w ##Class(web.DHCAppPisMaster).InsCheckSend("1")
ClassMethod InsCheckSend(Pid As %String = "") As %String
{
	n (Pid)
	s rtn = 1
	if (Pid'=""){
		s Flag=$p(^DHCAPPPM(Pid),"^",9)
		if (Flag="Y"){
			s rtn=1
		}elseif(Flag="D"){
			s rtn=3
		}else{
			s rtn=0
		}
	}else{
		s rtn=2
	}
	Q rtn
}

Storage Default
{
<Data name="DHCAppPisMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCAppPisMasterD</DataLocation>
<DefaultData>DHCAppPisMasterDefaultData</DefaultData>
<IdLocation>^web.DHCAppPisMasterD</IdLocation>
<IndexLocation>^web.DHCAppPisMasterI</IndexLocation>
<StreamLocation>^web.DHCAppPisMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
