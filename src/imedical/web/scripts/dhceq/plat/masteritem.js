//modified by cjt 20230212 需求号3221933 UI页面改造
initEquipAttribute();
//Creator:CZF0138 2021-04-28
//description:医院设备项维护
var ETColumns=getCurColumnsInfo('PLAT.L.EquipType','','','');
var Columns=getCurColumnsInfo('Plat.G.GetMasterItem','','','');
var SelectedRow = -1 ; 
var SelectedMstItemRow = -1;

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  //界面加载效果影藏
});

function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle();
	initLookUp();
	initButton();
	//initButtonWidth();
	disabled(true);		//1969883 czf
	muilt_Tab();  // 回车下一输入框
	///modified by ZY0302 20220601
	setRequiredElements("MICode^MIEquipTypeDR_ETDesc^MIDesc^MIStatCatDR_SCDesc^MIUnitDR_UOMDesc^MICatDR_ECDesc");
	initEquipAttributeCat();	//设备属性分类
	singlelookup("KBSMasterItemDR_MIDesc","Plat.L.KBSMasterItem",[{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{name:"Name",type:1,value:"KBSMasterItemDR_MIDesc"},{"name":"EquipCatDR","type":"4","value":"MICatDR"}],GetKBSMasterItem)
	singlelookup("MIStandItemDR_MIDesc","Plat.L.StandardItem",[{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{name:"Name",type:1,value:"StandardItemDR_MIDesc"},{"name":"EquipCatDR","type":"4","value":"MICatDR"}],GetStandardItem)
	
    	singlelookup("MICFDADR_TDesc","EM.L.Tree",[{"name":"Desc","type":"1","value":"MIDesc"}],GetMICFDAList);
    	
	initBDPHospComponent("DHC_EQCMasterItem");	//CZF0138 多院区改造
	var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//是否新窗口打开分类树
	if (!+CatShow)
	{
		initEquipCatTree();
	}
	else
	{
		singlelookup("MICatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"MICatDR_ECDesc"},{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{"name":"EditFlag","type":"2","value":"1"}])
	}
	///end modified by ZY0302 20220601
	initEquipTypeGrid();
	initMasterItemGrid();
	initEvent();
	//modified by ZY0306 2767727
	alertShow("请先选择左侧类组后再填写信息!")
}

//CZF0138 平台医院组件选择事件
function onBDPHospSelectHandler()
{
	initEquipTypeGrid();
	Clear();
	setElement("MIEquipTypeDR","");
	setElement("MIEquipTypeDR_ETDesc","");
	initMasterItemGrid();
}
//modified by cjt 20230212 需求号3221933 UI页面改造
function initEquipAttribute()
{
	var jsonData=tkMakeServerCall("web.DHCEQCMasterItem","ReturnJsonEquipAttribute")
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
    $("#EquipAttributeList").keywords({
	    onUnselect:function(v){
		    initEquipAttributeCat()
		},
	    onSelect:function(v){
		    initEquipAttributeCat()
		},
	    items:string
    });
    var height=$("#EquipAttributeList").height();
    $("#EquipAttribute").attr("style","padding-bottom:"+(height-28)+"px");
}
function initEquipAttributeCat()
{
	/*
	var jsonData=tkMakeServerCall("web.DHCEQCMasterItem","GetEquipAttributeCat")
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
    $("#EquipAttributeCat").keywords({
       items:string
    });
    */
    //设备属性相关调整
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	if(i>0)  //修改设备属性不能完全删除的问题
	{
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id.slice(2)
			}else
			{
				EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id.slice(2)
			}
		}
	}
	else
	{
		var EquipAttributeString=""
	}
    $HUI.combogrid('#IHTDesc',{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSAttributeCat",
	        QueryName:"GetAttributeCat",
	        TypeIDStr:EquipAttributeString
	    },
	    idField:'TRowID',
		textField:'TName',
	    multiple: true,
	    rowStyle:'checkbox', //显示成勾选行形式
	    selectOnNavigation:false,
	    fitColumns:true,
	    fit:true,
	    border:'true',
	    //singleSelect: true,
		//selectOnCheck: true,
		//checkOnSelect: true
	    columns:[[
	    	{field:'check',checkbox:true},
	    	{field:'TRowID',title:'TRowID',width:50,hidden:true},
	        {field:'TName',title:'全选',width:150}
	    ]]
    });
}
///modified by ZY0302 20220601
function initEquipCatTree()
{
	var EquipeCatTree=$.m({
		    ClassName:"web.DHCEQ.Plat.LIBTree",
		    MethodName:"GetEquipeCatTreeStr",
			parid:'0',       //Modefied by zc0119 增加参数  begin
		    tEquipTypeDR:getElementValue("MIEquipTypeDR"),
		    tStatCatDR:getElementValue("MIStatCatDR")    //Modefied by zc0119 增加参数  end
		},false);
		
	var cbtree = $HUI.combotree('#MICatDR_ECDesc',{
		panelWidth:400,
		panelHeight:400,
		editable:true,
		onChange: function (newValue, oldValue) {
			setElement("MICatDR",newValue);
		}
		});
	cbtree.loadData(JSON.parse(EquipeCatTree));
}

function initEvent()
{
	var obj=document.getElementById("MIDesc");
	if (obj) obj.onchange=GetCode;
}

function initEquipTypeGrid()
{
	EquipTypeGrid=$HUI.datagrid("#DHCEQCMasterItemList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTEquipType",
			QueryName:"GetEquipType",
			GroupID:curSSGroupID,
			Flag:"0",
			FacilityFlag:"2",
			gHospId:curSSHospitalID,
			BDPHospId:GetBDPHospValue("_HospList")
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true, 
	    columns:ETColumns,
	    onClickRow:function(rowIndex, rowData){
		    SelectRowHandler(rowIndex,rowData);
		},
		onLoadSuccess:function(){
		}
	});
}

function initMasterItemGrid()
{
	var Params=getInputList();
	Params["gHospId"]=curSSHospitalID;
	Params["BDPHospId"]=GetBDPHospValue("_HospList");
	Params=JSON.stringify(Params);
	MasterItemGrid = $HUI.datagrid("#DHCEQCMasterItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.CTMasterItem",
			QueryName:"MasterItem",
			EquipTypeDR:getElementValue("MIEquipTypeDR"),
			Params:Params,
			EquipAttributeString:GetEquipAttributeStringData(),  //added by LMH 20220909 2651629 增加Query入参
			EquipAttributeStringCat:GetEquipAttributeCatData(),	 //added by LMH 20220909 2651629 增加Query入参
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true, 
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	    onClickRow:function(rowIndex, rowData){
		    SelectMstItemRowHandler(rowIndex,rowData);
		},
		onLoadSuccess:function(){
		}
	});
}

//数据关联医院按钮点击事件
function HospitalHandle()
{
	var MIRowID=getElementValue("MIRowID");
	if(MIRowID==""){
		$.messager.alert("提示", "请选择设备项!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCMasterItem",MIRowID,function(){
		//回调函数;
	});
}

function CombinData()
{
	var combindata="";
    combindata=getElementValue("MIRowID") ;
	combindata=combindata+"^"+getElementValue("MIDesc") ;
  	combindata=combindata+"^"+getElementValue("MICode") ; 
  	combindata=combindata+"^"+getElementValue("MIEquipTypeDR") ;
  	combindata=combindata+"^"+getElementValue("MICatDR") ;	///modified by ZY0302 20220601
  	combindata=combindata+"^"+getElementValue("MIStatCatDR") ;
  	combindata=combindata+"^"+getElementValue("MIRemark") ;
  	combindata=combindata+"^"+getElementValue("MIUnitDR") ; 
  	combindata=combindata+"^" ;		//getElementValue("InvalidFlag")
  	combindata=combindata+"^" ; 	//GetChkElementValue("ForceInspectFlag")
  	combindata=combindata+"^"+getElementValue("MIHold1") ; 
  	combindata=combindata+"^" ; 	//+getElementValue("Hold2")
  	combindata=combindata+"^" ;		//+GetChkElementValue("Hold3")
  	combindata=combindata+"^" ; 	//+getElementValue("Hold4")
  	combindata=combindata+"^" ; 	//+getElementValue("Hold5")
  	combindata=combindata+"^" ;		//+getElementValue("MeasureFee")
  	combindata=combindata+"^"+getElementValue("IsStandard") ;	//add by czf 2021-07-16 是否作为标准设备项
  	combindata=combindata+"^"+getElementValue("StandardItemDR") ; //add by czf 2021-07-16 标准设备项ID
  	return combindata;
}

function BSave_Clicked() 
{
	///add by ZY0303 20220616
	if (!charLegalCheck("MICode^MIDesc")) return true;
	
	//if (checkMustItemNull()) return;
	if (condition()) return;
	if (CheckEquipCat(getElementValue("MICatDR"))<0)	///modified by ZY0302 20220601
	{
		alertShow("设备分类设置有误!")
		return
	}
	var result=CheckEqCatIsEnd(getElementValue("MICatDR"))	///modified by ZY0302 20220601
	if ((result=="0")||(result=="2"))
	{
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	//var plist=CombinData();	///modified by ZY0302 20220601
	
	//设备属性相关调整
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	if(i>0)  //修改设备属性不能完全删除的问题
	{
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id
			}else
			{
				EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id
			}
		}
	}
	else
	{
		var EquipAttributeString=""
	}
	
	var EquipAttributeStringCat=$("#IHTDesc").combogrid("getValues");
	EquipAttributeStringCat=EquipAttributeStringCat.toString();
	///modified by ZY0302 20220601
	var data=getInputList();
	data=JSON.stringify(data);
	//modified by ZY0306 	2767426
	//disableElement("BSave",true)
	var result=tkMakeServerCall("web.DHCEQ.EM.CTMasterItem","SaveData",'','',data,"",EquipAttributeString,curSSHospitalID,GetBDPHospValue("_HospList"),EquipAttributeStringCat);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		//modified by ZY0306 	2767426
		//disableElement("BSave",false)
		alertShow("数据重复,重新核实!")
		return
	}
	if (result>0)
	{
		alertShow("操作成功!")
		Clear();
		MasterItemGrid.reload();
	}	
}

function BDelete_Clicked() 
{
	rowid=getElementValue("MIRowID");
	messageShow("confirm","info","提示","是否确认删除?","",function(){
		deleteData(rowid);
		},function(){
			return;
	});
}

//1969873 czf
function deleteData(rowid){
	var result=tkMakeServerCall("web.DHCEQ.EM.CTMasterItem","SaveData",'','',rowid,'1','',curSSHospitalID,GetBDPHospValue("_HospList"));
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功!")
		Clear();
		MasterItemGrid.reload();
	}
}

function BFind_Clicked()
{
	initMasterItemGrid();
}

function BClear_Clicked()
{
	Clear();
}

function setSelectValue(elementID,rowData)
{
	///modified by ZY0302 20220601
	if (elementID=="MICFDADR_TDesc") {
		setElement("MICFDADR",rowData.TRowID)
		setElement("MICFDADR_TDesc",rowData.TName)
		setElement("MICFDADR_TCode",rowData.TCode)
		setElement("MIManageLevel",rowData.TLRowID)
		setElement("MIManageLevel",rowData.TLManageLevel)
	}
	else {setDefaultElementValue(elementID,rowData)}
}

//设备类组选中行事件
function SelectRowHandler(index,rowdata)
{
	Selected(index , rowdata);
}
function Selected(selectrow, rowdata)
{	
	if (SelectedRow==selectrow)	
	{	
		SelectedRow=-1;
		setElement("MIEquipTypeDR","");
		setElement("MIEquipTypeDR_ETDesc","");
		$('#DHCEQCMasterItemList').datagrid('unselectAll');	//2260030
	}else{
		SelectedRow=selectrow;
		setElement("MIEquipTypeDR",rowdata.TRowID);
		setElement("MIEquipTypeDR_ETDesc",rowdata.TName);
		var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//Modefied by zc0119 是否新窗口打开分类树 begin
		if (!+CatShow)
		{
			initEquipCatTree();
		}
		//Modefied by zc0119 是否新窗口打开分类树 end
		//modified by ZY0306 20220707  专用设备时医疗器械分类必填
		if (rowdata.TRowID==3) setRequiredElements("MICFDADR_TDesc",true);
		else setRequiredElements("MICFDADR_TDesc",false);
	}
	Clear();
	initMasterItemGrid();	
}

function SelectMstItemRowHandler(index,rowdata)
{	
	if (SelectedMstItemRow==index){
		Clear();
		disabled(true)	
		SelectedMstItemRow=-1;
		rowid=0;
		setElement("MIRowID","");
		$("#EquipAttributeList").keywords("clearAllSelected")
		$('#DHCEQCMasterItem').datagrid('unselectAll'); 	//1969892 czf
		return;
	}else{
		SelectedMstItemRow=index;
		rowid=rowdata.TRowID   
		SetData(rowid);
		SetEquipAttribute(rowid)
		SetEquipAttributeCat(1,rowid);		//czf 2022-04-14
		disabled(false)
	}
}

function Clear()
{
	setElement("MIRowID","");
	setElement("MICode",""); 
	setElement("MIDesc","");
	setElement("MICatDR","");	///modified by ZY0302 20220601
	var jObj=$("#MICatDR_ECDesc")	///modified by ZY0302 20220601
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',""); 
		var t = $("#MICatDR_ECDesc").combotree('tree');
		collapseAllNode(t);
	}
	else
	{
		setElement("MICatDR_ECDesc","");
	}
	setElement("MIStatCatDR","");
	setElement("MIStatCatDR_SCDesc","");
	setElement("MIRemark","");
	setElement("MICFDADR","");
	setElement("MICFDADR_TDesc","");
	setElement("MICFDADR_TCode","");
	setElement("MICFDAListDR","");
	
	setElement("MIHospitalDR","");
	setElement("MIManageLevel","");
	setElement("MILocalWJWCode","");
	setElement("MILocalFinanceCode","");
	
	setElement("MIMedicalFlag","");
	setElement("MIRaditionFlag","");
	setElement("MIHoldCat","");
	setElement("MIUnitDR","");
	setElement("MIUnitDR_UOMDesc","");
	setElement("MIMeasureFee","");
	setElement("MIStandFlag","");
	setElement("MIStandItemDR","");
	setElement("MIStandItemDR_MIDesc","");
	setElement("MIHold9","");
	setElement("MIHold10","");
	setElement("MIHold11","");
	setElement("MIHold12","");
	///end modified by ZY0302 20220601
	$("#EquipAttributeList").keywords("clearAllSelected");
	//setElement("MeasureFee","");
	setElement("KBSMasterItemDR_MIDesc","");
	setElement("KBSMasterItemDR","");
	setElement("IHTDesc","");	//属性分类 czf 2022-04-14
}

function SetData(rowid)
{
	///modified by ZY0302 20220601
	if (rowid=="") return;
	jsonData=tkMakeServerCall("web.DHCEQ.EM.CTMasterItem","GetOneMasterItem",rowid)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
	
	var MICatDR=oneFillData.MICatDR
	var MICatDRECDesc=oneFillData.MICatDR_ECDesc
	var jObj=$("#MICatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',MICatDR);
		var t = $("#MICatDR_ECDesc").combotree('tree');
		var node = t.tree('find', MICatDR);
		if (node!=null)
		{
			expandParent(t,node);
			t.tree("scrollTo",node.target);
		}
	}
	else
	{
		setElement("MICatDR_ECDesc",MICatDRECDesc);
	}
	///end modified by ZY0302 20220601
}

function disabled(value)
{
	if (getElementValue("ReadOnly")==1)
	{
		disableElement("BDelete",true)
	}else{
		//disableElement("BSave",value)
		disableElement("BDelete",value)
	}
}

//Add by jyp 2019-09-02 设备属性相关调整
//用于处理选择设备项后显示对应的设备属性
//入参：TRowID 设备项id
function SetEquipAttribute(TRowID)
{
	CodeString=tkMakeServerCall("web.DHCEQ.EM.BUSEquipAttribute","GetOneEquipAttribute","1",TRowID)
	list=CodeString.split("^");
	var i=list.length;
	$("#EquipAttributeList").keywords("clearAllSelected")
	if(CodeString!="")
	{	
		for (var j=0;j<i;j++)
		{
			$("#EquipAttributeList").keywords("select",list[j]);
		}
	}
}

///描述:检测设备分类是否分类正确,
///返回值:0:正确, -1:错误
function CheckEquipCat(EquipCatRowID)
{
	if (EquipCatRowID=="") return 0;
	var rtn=tkMakeServerCall("web.DHCEQEquip","GetEquipeCatCode",EquipCatRowID);
	if (rtn=="") return -1;
	return rtn
}

/// 描述:判断设备类组是否选择最末级
/// 返回值:0:否 1:是 2:非最末级时提示但不限制
function CheckEqCatIsEnd(CatID)
{
	if (CatID=="") return 1
	var result=tkMakeServerCall("web.DHCEQCommon","CheckEqCatIsEnd",CatID);
	return result
}

function initKeywords()
{
	if(getElementValue("EquipAttributeString")!="")
	{ 
		var arr=new Array()
		var  CurData=getElementValue("EquipAttributeString");
		var SplitNumCode=getElementValue("SplitNumCode");
		arr = CurData.split(SplitNumCode);
		for(var i=0 ;i <arr.length;i++)
		{ 
			$("#EquipAttributeList").keywords("select",arr[i])
		}
	}
 }	

function getKeywordsData()
{ 
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var EquipAttributeString=""
	for (var j=0;j<SelectType.length;j++)
	{
		if(EquipAttributeString=="")
		{
			EquipAttributeString=SelectType[j].id
		}else
		{
			EquipAttributeString=EquipAttributeString+getElementValue("SplitNumCode")+SelectType[j].id
		}
	}
	return EquipAttributeString;
	
}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function condition()
{
	if(getElementValue("MICode")==""){alertShow("代码不能为空");return true;}
	else if(getElementValue("MIDesc")==""){alertShow("描述不能为空");return true;}
	else if(getElementValue("MIEquipTypeDR")==""){alertShow("管理类组不能为空");return true;}
	else if(getElementValue("MIStatCatDR")==""){alertShow("设备类型不能为空");return true;}
	else if(getElementValue("MICatDR")==""){alertShow("设备分类不能为空");return true;}	///modified by ZY0302 20220601
	else if(getElementValue("MIUnitDR")==""){alertShow("单位不能为空");return true;}
}

///根据叶子节点展开所有父节点
function expandParent(treeObj, curnode)
{
    var parentNode = treeObj.tree("getParent", curnode.target);
    if(parentNode != null && parentNode != "undefined"){
	    treeObj.tree("expand", parentNode.target);
	    expandParent(treeObj, parentNode);
    }
    else
    {
	    treeObj.tree("expand", curnode.target);
	}
}

///返回当前节点的首级节点
function getFirstTreeNode(treeObj, curnode)
{
	var parentNode = treeObj.tree("getParent", curnode.target);
	if(parentNode != null && parentNode != "undefined"){
    	return getFirstTreeNode(treeObj, parentNode);
    }
    else
    {
    	return curnode;
    }
}

//折叠所有节点
function collapseAllNode(treeObj)
{
	var roots=treeObj.tree("getRoots");
    for(var j=0; j<roots.length; j++){
        var rootnode=roots[j];
        if(rootnode!=null&& rootnode != "undefined")
        {
            treeObj.tree("collapseAll",rootnode.target);
        }
    }
}

function GetCode()
{
	var Desc=getElementValue("MIDesc");
	var Code=getPYCode(Desc);
	setElement("MICode",Code);
}

///CZF 2021-07-15 1967027
///参考设备项回调函数
function GetKBSMasterItem(item)
{
	setElement("KBSMasterItemDR_MIDesc",item.TName);
	setElement("KBSMasterItemDR",item.TRowID);
	setElement("MIDesc",item.TName);
	setElement("MICode",item.TCode);
	setElement("MIStatCatDR_SCDesc",item.TStatCat);
	setElement("MIStatCatDR",item.TStatCatDR);
	///modified by ZY0302 20220601
	//setElement("MICatDR_ECDesc",item.TCatDesc);
	setElement("MICatDR",item.TCatDR);
	var jObj=$("#MICatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',item.TCatDR);
		var t = $("#MICatDR_ECDesc").combotree('tree');
		var node = t.tree('find', item.TCatDR);
		if (node!=null)
		{
			expandParent(t,node);
			t.tree("scrollTo",node.target);
		}
	}
	else
	{
		setElement("MICatDR_ECDesc",item.TCatDesc);
	}
	///end modified by ZY0302 20220601
	setElement("MIUnitDR_UOMDesc",item.TUnit);
	setElement("MIUnitDR",item.TUnitDR);
}

// CZF 2021-07-15 1967027
// 标准设备项回调函数
function GetStandardItem(item)
{
	///modified by ZY0302 20220601
	setElement("MIStandItemDR_MIDesc",item.TName);
	setElement("MIStandItemDR",item.TRowID);
}
///modified by ZY0302 20220601
function GetMICFDAList(item)
{
	setElement("MICFDADR_TDesc",item.TName);
	setElement("MICFDADR",item.TRowID);
	setElement("MICFDADR_TCode",item.TCode);
	setElement("MICFDAListDR",item.TLRowID);
	setElement("MIManageLevel",item.TLManageLevel);
	//setElement("MICFDAListDR",item.TLProductNames);
	//setElement("MICFDAListDR",item.TLProductDesc);
	//setElement("MICFDAListDR",item.TLPurposeDesc);

}
//czf 2022-04-14
//设备属性分类
function SetEquipAttributeCat(sourceType,sourceID)
{
	var catString=tkMakeServerCall("web.DHCEQ.EM.BUSAttributeCat","GetOneEquipAttributeCat",sourceType,sourceID)
	if (catString!="")
	{
		var list=catString.split(",");
		$('#IHTDesc').combogrid('setValues', list);
	}
	
}
/**
 * 属性分类数据获取  added by LMH 20220909 2651629 增加Query入参
 * @param {string} 无
 * @param {Object} 无
 * @returns  EquipAttributeStringCat
 * @author 刘梦辉 
 */
 function GetEquipAttributeCatData()
 {
	var EquipAttributeStringCat="";
	if ($("#IHTDesc").length>0) EquipAttributeStringCat=$("#IHTDesc").combogrid("getValues");
	EquipAttributeStringCat=EquipAttributeStringCat.toString();
	return EquipAttributeStringCat;
 }
 /**
 * 设备属性数据获取 modified by LMH 20220909 2651629 增加Query入参
 * @param {string} 无
 * @param {Object} 无
 * @returns    EquipAttributeString
 * @author 刘梦辉  
 */
 function GetEquipAttributeStringData()
{ 
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var EquipAttributeString="";
	if ((SelectType)||(SelectType!=undefined))
	{
		var i=SelectType.length;
		var EquipAttributeString=""
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id;
			}else
			{
				EquipAttributeString=EquipAttributeString+"^"+SelectType[j].id;
			}
		}
	}
	return EquipAttributeString;
	
}
