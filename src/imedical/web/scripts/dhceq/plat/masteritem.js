//modified by cjt 20230212 �����3221933 UIҳ�����
initEquipAttribute();
//Creator:CZF0138 2021-04-28
//description:ҽԺ�豸��ά��
var ETColumns=getCurColumnsInfo('PLAT.L.EquipType','','','');
var Columns=getCurColumnsInfo('Plat.G.GetMasterItem','','','');
var SelectedRow = -1 ; 
var SelectedMstItemRow = -1;

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});  //�������Ч��Ӱ��
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
	muilt_Tab();  // �س���һ�����
	///modified by ZY0302 20220601
	setRequiredElements("MICode^MIEquipTypeDR_ETDesc^MIDesc^MIStatCatDR_SCDesc^MIUnitDR_UOMDesc^MICatDR_ECDesc");
	initEquipAttributeCat();	//�豸���Է���
	singlelookup("KBSMasterItemDR_MIDesc","Plat.L.KBSMasterItem",[{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{name:"Name",type:1,value:"KBSMasterItemDR_MIDesc"},{"name":"EquipCatDR","type":"4","value":"MICatDR"}],GetKBSMasterItem)
	singlelookup("MIStandItemDR_MIDesc","Plat.L.StandardItem",[{name:"EquipTypeDR",type:4,value:"MIEquipTypeDR"},{name:"StatCatDR",type:4,value:"MIStatCatDR"},{name:"Name",type:1,value:"StandardItemDR_MIDesc"},{"name":"EquipCatDR","type":"4","value":"MICatDR"}],GetStandardItem)
	
    	singlelookup("MICFDADR_TDesc","EM.L.Tree",[{"name":"Desc","type":"1","value":"MIDesc"}],GetMICFDAList);
    	
	initBDPHospComponent("DHC_EQCMasterItem");	//CZF0138 ��Ժ������
	var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//�Ƿ��´��ڴ򿪷�����
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
	alertShow("����ѡ��������������д��Ϣ!")
}

//CZF0138 ƽ̨ҽԺ���ѡ���¼�
function onBDPHospSelectHandler()
{
	initEquipTypeGrid();
	Clear();
	setElement("MIEquipTypeDR","");
	setElement("MIEquipTypeDR_ETDesc","");
	initMasterItemGrid();
}
//modified by cjt 20230212 �����3221933 UIҳ�����
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
    //�豸������ص���
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	if(i>0)  //�޸��豸���Բ�����ȫɾ��������
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
	    rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
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
	        {field:'TName',title:'ȫѡ',width:150}
	    ]]
    });
}
///modified by ZY0302 20220601
function initEquipCatTree()
{
	var EquipeCatTree=$.m({
		    ClassName:"web.DHCEQ.Plat.LIBTree",
		    MethodName:"GetEquipeCatTreeStr",
			parid:'0',       //Modefied by zc0119 ���Ӳ���  begin
		    tEquipTypeDR:getElementValue("MIEquipTypeDR"),
		    tStatCatDR:getElementValue("MIStatCatDR")    //Modefied by zc0119 ���Ӳ���  end
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
			EquipAttributeString:GetEquipAttributeStringData(),  //added by LMH 20220909 2651629 ����Query���
			EquipAttributeStringCat:GetEquipAttributeCatData(),	 //added by LMH 20220909 2651629 ����Query���
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

//���ݹ���ҽԺ��ť����¼�
function HospitalHandle()
{
	var MIRowID=getElementValue("MIRowID");
	if(MIRowID==""){
		$.messager.alert("��ʾ", "��ѡ���豸��!", 'info');
		return 
	}
	genHospWinNew("DHC_EQCMasterItem",MIRowID,function(){
		//�ص�����;
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
  	combindata=combindata+"^"+getElementValue("IsStandard") ;	//add by czf 2021-07-16 �Ƿ���Ϊ��׼�豸��
  	combindata=combindata+"^"+getElementValue("StandardItemDR") ; //add by czf 2021-07-16 ��׼�豸��ID
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
		alertShow("�豸������������!")
		return
	}
	var result=CheckEqCatIsEnd(getElementValue("MICatDR"))	///modified by ZY0302 20220601
	if ((result=="0")||(result=="2"))
	{
		alertShow("��ǰѡ���豸���಻����ĩ��!")
		if (result=="0") return
	}
	//var plist=CombinData();	///modified by ZY0302 20220601
	
	//�豸������ص���
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var i=SelectType.length;
	var EquipAttributeString=""
	if(i>0)  //�޸��豸���Բ�����ȫɾ��������
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
		alertShow("�����ظ�,���º�ʵ!")
		return
	}
	if (result>0)
	{
		alertShow("�����ɹ�!")
		Clear();
		MasterItemGrid.reload();
	}	
}

function BDelete_Clicked() 
{
	rowid=getElementValue("MIRowID");
	messageShow("confirm","info","��ʾ","�Ƿ�ȷ��ɾ��?","",function(){
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
		alertShow("ɾ���ɹ�!")
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

//�豸����ѡ�����¼�
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
		var CatShow=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990052")	//Modefied by zc0119 �Ƿ��´��ڴ򿪷����� begin
		if (!+CatShow)
		{
			initEquipCatTree();
		}
		//Modefied by zc0119 �Ƿ��´��ڴ򿪷����� end
		//modified by ZY0306 20220707  ר���豸ʱҽ����е�������
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
	setElement("IHTDesc","");	//���Է��� czf 2022-04-14
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

//Add by jyp 2019-09-02 �豸������ص���
//���ڴ���ѡ���豸�����ʾ��Ӧ���豸����
//��Σ�TRowID �豸��id
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

///����:����豸�����Ƿ������ȷ,
///����ֵ:0:��ȷ, -1:����
function CheckEquipCat(EquipCatRowID)
{
	if (EquipCatRowID=="") return 0;
	var rtn=tkMakeServerCall("web.DHCEQEquip","GetEquipeCatCode",EquipCatRowID);
	if (rtn=="") return -1;
	return rtn
}

/// ����:�ж��豸�����Ƿ�ѡ����ĩ��
/// ����ֵ:0:�� 1:�� 2:����ĩ��ʱ��ʾ��������
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
	if(getElementValue("MICode")==""){alertShow("���벻��Ϊ��");return true;}
	else if(getElementValue("MIDesc")==""){alertShow("��������Ϊ��");return true;}
	else if(getElementValue("MIEquipTypeDR")==""){alertShow("�������鲻��Ϊ��");return true;}
	else if(getElementValue("MIStatCatDR")==""){alertShow("�豸���Ͳ���Ϊ��");return true;}
	else if(getElementValue("MICatDR")==""){alertShow("�豸���಻��Ϊ��");return true;}	///modified by ZY0302 20220601
	else if(getElementValue("MIUnitDR")==""){alertShow("��λ����Ϊ��");return true;}
}

///����Ҷ�ӽڵ�չ�����и��ڵ�
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

///���ص�ǰ�ڵ���׼��ڵ�
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

//�۵����нڵ�
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
///�ο��豸��ص�����
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
// ��׼�豸��ص�����
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
//�豸���Է���
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
 * ���Է������ݻ�ȡ  added by LMH 20220909 2651629 ����Query���
 * @param {string} ��
 * @param {Object} ��
 * @returns  EquipAttributeStringCat
 * @author ���λ� 
 */
 function GetEquipAttributeCatData()
 {
	var EquipAttributeStringCat="";
	if ($("#IHTDesc").length>0) EquipAttributeStringCat=$("#IHTDesc").combogrid("getValues");
	EquipAttributeStringCat=EquipAttributeStringCat.toString();
	return EquipAttributeStringCat;
 }
 /**
 * �豸�������ݻ�ȡ modified by LMH 20220909 2651629 ����Query���
 * @param {string} ��
 * @param {Object} ��
 * @returns    EquipAttributeString
 * @author ���λ�  
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
