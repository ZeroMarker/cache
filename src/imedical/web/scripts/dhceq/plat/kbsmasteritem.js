//Creator:CZF0138 2021-04-28
//description:标准设备项维护
var Columns=getCurColumnsInfo('Plat.G.GetKBSMasterItem','','','');
var SelectedRow = -1 ; 

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
	initButtonWidth();
	muilt_Tab();  	// 回车下一输入框
	setRequiredElements("SMICode^SMIFinanceTypeDR_FTDesc^SMIDesc^SMIStatCatDR_SCDesc^SMIUnitDR_UOMDesc^SMICatDR_ECDesc");
	var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//是否新窗口打开分类树
	if (!+CatShow)
	{
		initEquipCatTree();
	}
	else
	{
		singlelookup("SMICatDR_ECDesc","EM.L.EquipCat",[{name:"Desc",type:1,value:"SMICatDR_ECDesc"},{"name":"EditFlag","type":"2","value":"1"}])
	}
	initMasterItemGrid();
	initEvent();
}

function initEquipCatTree()
{
	var EquipeCatTree=$.m({
		    ClassName:"web.DHCEQ.Plat.LIBTree",
		    MethodName:"GetEquipeCatTreeStr"
		},false);
		
	var cbtree = $HUI.combotree('#SMICatDR_ECDesc',{
		panelWidth:400,
		panelHeight:400,
		editable:true,
		onChange: function (newValue, oldValue) {
			setElement("SMICatDR",newValue);
		}
		});
	cbtree.loadData(JSON.parse(EquipeCatTree));
}

function initEvent()
{
	var obj=document.getElementById("SMIDesc");
	if (obj) obj.onchange=GetCode;
}

function initMasterItemGrid()
{
	var Params=getInputList();
	Params=JSON.stringify(Params);
	MasterItemGrid = $HUI.datagrid("#tDHCEQKBSMasterItem",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.EM.KBSMasterItem",
			QueryName:"KBSMasterItem",
			Params:Params
		},
		border:false,
	    fit:true,
		fitColumns:true,
	    singleSelect:true,
	    //rownumbers: true, 
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	    onClickRow:function(rowIndex, rowData){
		    SelectRowHandler(rowIndex,rowData);
		},
		onLoadSuccess:function(){
		}
	});
}

function BSave_Clicked() 
{
	if (condition()) return;
	if (CheckEquipCat(getElementValue("SMICatDR"))<0){
		alertShow("设备分类设置有误!")
		return
	}
	var result=CheckEqCatIsEnd(getElementValue("SMICatDR"))
	if ((result=="0")||(result=="2")){
		alertShow("当前选择设备分类不是最末级!")
		if (result=="0") return
	}
	var plist=JSON.stringify(getInputList());
	var result=tkMakeServerCall("web.DHCEQ.EM.KBSMasterItem","SaveData",plist,"");
	result=JSON.parse(result);
	if(result.SQLCODE!=0){
		messageShow("alert","error","","保存失败!"+result.Data);
		return;
	}else{
		messageShow("alert","success","","保存成功!");
		Clear();
		MasterItemGrid.reload();
	}	
}

function BDelete_Clicked() 
{
	rowid=getElementValue("SMIRowID");
	if (rowid=="") return;
	messageShow("confirm","","","确认删除吗?","",function (){
		var result=tkMakeServerCall("web.DHCEQ.EM.KBSMasterItem","SaveData",rowid,'1');
		result=JSON.parse(result);
		if (result.SQLCODE==0)
		{
			messageShow("alert","success","","删除成功!")
			Clear();
			MasterItemGrid.reload();
		}
		else
		{
			messageShow("alert","error","","删除失败!+错误信息:"+result.Data)
			return;
		}
		
	},function (){
	return
	});	
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
	setDefaultElementValue(elementID,rowData)
}

function SelectRowHandler(index,rowdata)
{	
	if (SelectedRow==index){
		Clear();
		disabled(true)	
		SelectedRow=-1;
		rowid=0;
		setElement("SMIRowID","");
		$('#tDHCEQKBSMasterItem').datagrid('unselectAll');  
	}else{
		SelectedRow=index;
		rowid=rowdata.TRowID
		SetData(rowid);
		disabled(false)
	}
}

function Clear()
{
	setElement("SMIRowID","");
	setElement("SMICode",""); 
	setElement("SMIDesc","");
	setElement("SMICatDR","");
	var jObj=$("#SMICatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',""); 
		var t = $("#SMICatDR_ECDesc").combotree('tree');
		collapseAllNode(t);
	}
	else
	{
		setElement("SMICatDR_ECDesc","");
	}
	setElement("SMIFinanceTypeDR","");
	setElement("SMIFinanceTypeDR_FTDesc","");
	setElement("SMIStatCatDR","");
	setElement("SMIStatCatDR_SCDesc","");
	setElement("SMIRemark","");
	setElement("SMIUnitDR","");
	setElement("SMIUnitDR_UOMDesc","");
	setElement("SMITreeDR","");
	setElement("SMITreeDR_TDesc","");
}

function SetData(rowid)
{
	jsonData=tkMakeServerCall("web.DHCEQ.EM.KBSMasterItem","GetOneKBSMstItem",rowid)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	var OneKBSMstItm=jsonData.Data;
	//设备分类赋值
	var jObj=$("#SMICatDR_ECDesc")
	var objClassInfo=jObj.prop("class")
	if (objClassInfo.indexOf("combotree")>=0){
		jObj.combotree('setValue',OneKBSMstItm.SMICatDR);
		var t = $("#SMICatDR_ECDesc").combotree('tree');
		var node = t.tree('find', OneKBSMstItm.SMICatDR);
		if (node!=null)
		{
			expandParent(t,node);
			t.tree("scrollTo",node.target);
		}
	}
	else
	{
		setElement("SMICatDR_ECDesc",OneKBSMstItm.SMICatDR_ECDesc);
	}
}

function disabled(value)
{
	if (getElementValue("ReadOnly")==1)
	{
		disableElement("BDelete",true)
	}else{
		disableElement("BDelete",value)
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
	if(getElementValue("SMICode")==""){alertShow("代码不能为空");return true;}
	else if(getElementValue("SMIDesc")==""){alertShow("描述不能为空");return true;}
	else if(getElementValue("SMIFinanceTypeDR")==""){alertShow("资产大类不能为空");return true;}
	else if(getElementValue("SMIStatCatDR")==""){alertShow("设备类型不能为空");return true;}
	else if(getElementValue("SMICatDR")==""){alertShow("设备分类不能为空");return true;}
	else if(getElementValue("SMIUnitDR")==""){alertShow("单位不能为空");return true;}
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
	var Desc=getElementValue("SMIDesc");
	var Code=getPYCode(Desc);
	setElement("SMICode",Code);
}

function clearData(elementID)
{
	var elementName=elementID.split("_")[0];
	setElement(elementName,"");
	
	return;
}