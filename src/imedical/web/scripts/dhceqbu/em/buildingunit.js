var columns=getCurColumnsInfo('PLAT.G.DT3D.Floor','','','');  
var buildunitcolumns=getCurColumnsInfo('PLAT.G.DT3D.BuildUnit','','','');  
var PreSelectedRowID=""
var PreSelectedBuildUnitRowID=""
$(document).ready(function () {
	initDocument();
});
var GlobalObj = {
	//Status:[{"value": "0","text": "���� "},{"value": "1","text": "����"},{"value": "2","text": "ԤԼ"},{"value": "3","text": "δ��"}],
	Status:[{"value": "0","text": "����δ�� "},{"value": "1","text": "����"},{"value": "2","text": "����ͣ��"},{"value": "3","text": "ԤԼ"},{"value": "4","text": "�����Ч"}],
	Purpose:[{"value": "1","text": "�ٴ�"},{"value": "2","text": "ҽ��"},{"value": "3","text": "ҽ��"},{"value": "3","text": "��������"}],
	ElectricCond:[{"value": "0","text": "��380V"},{"value": "1","text": "�߱�380V"},{"value": "2","text": "��380V�ɸ���"}],
	WaterCond:[{"value": "0","text": "������ˮ"},{"value": "1","text": "������ˮ"},{"value": "2","text": "�ɸ�������ˮ"}],
	SewageDisposal:[{"value": "0","text": "����ˮ����"},{"value": "1","text": "����ˮ����"},{"value": "2","text": "�ɸ���"}],
	RadProtect:[{"value": "0","text": "�޷������"},{"value": "1","text": "�з������"},{"value": "2","text": "�ɸ���"}]
}
function initDocument()
{
	initUserInfo();
	defindTitleStyle(); 
	initButtonWidth();
    initMessage();
	initButton();
	initLookUp();
	initBuildingInfo()
    setRequiredElements("FFloorNum^FFloorNo^FFloorIndex^BUBuildingDR") 
    setRequiredElements("BUDesc^BUDoorNo^BUUseLocDR_DeptDesc^BUUseLocDR^BUFloorIndex^BUBuildingDR") 
    initCombox()
	$HUI.datagrid("#Floor",{   
	   	url:$URL, 
		idField:'FRowID', //����   //add by lmm 2018-10-23
	    border : false,
		//striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:true,
	    queryParams:{
	        ClassName:"web.DHCDT3D.Floor",
	        QueryName:"GetFloor",
	        BuildingDR:getElementValue("FBuildingDR"),
	        FloorNo:getElementValue("FFloorNo"),
		},
    	toolbar:[
//    		{
//	    		id:"Add",
//				iconCls:'icon-add', 
//				text:'����',
//				handler:function(){AddGridData("User.DHCEQFloor");}
//			},
    		{
	    		id:"Save",
				iconCls:'icon-save', 
				text:'�޸�',
				handler:function(){AddGridData("User.DHCEQBUFloor");}
			},
    		/*{
	    		id:"Delete",
				iconCls:'icon-cancel', 
				text:'ɾ��',
				handler:function(){DeleteGridData();}
			},
    		{
	    		id:"Find",
				iconCls:'icon-search', 
				text:'����',
				handler:function(){FindFloorGridData();}
			},*/
		], 
		onClickRow:function(rowIndex,rowData){
			onClickFloorRow(rowIndex,rowData);
			onClickRow(rowIndex,rowData)
			},
		//fitColumns:true,
		pagination:true,
    	columns:columns, 
	});
		
		
		
		$HUI.datagrid("#BuildingUnit",{   
	   	url:$URL, 
		idField:'BURowID', //����   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    singleSelect:false,
	    queryParams:{
	        ClassName:"web.DHCDT3D.BuildingUnit",
	        QueryName:"GetBuildingUnitDetail",
	        BuildingDR:getElementValue("FBuildingDR"),
	        FloorIndex:getElementValue("FFloorIndex"),
	        DoorNo:getElementValue("BUDoorNo"),
		},
    	toolbar:[
    		{
	    		id:"Add",
				iconCls:'icon-add', 
				text:'����',
				handler:function(){insertRow();}
			},
    		{
	    		id:"Save",
				iconCls:'icon-save', 
				text:'�޸�',
				handler:function(){AddBuildingUnitGridData("User.DHCEQBUBuildingUnit");}
			},
    		{
	    		id:"Delete",
				iconCls:'icon-cancel', 
				text:'ɾ��',
				handler:function(){DeleteBuildUnitGridData();}
			},
    		/*{
	    		id:"Find",
				iconCls:'icon-search', 
				text:'����',
				handler:function(){FindBuildUnitGridData();}
			},*/
		], 
		onDblClickRow:function(rowIndex,rowData){onClickBuildUnitRow(rowIndex,rowData);
		},
		//fitColumns:true,
		pagination:true,
    	columns:buildunitcolumns, 
	});
	var BUStatusDesc=$("#BuildingUnit").datagrid('getColumnOption','BUStatusDesc');	
	BUStatusDesc.editor={type: 'combobox',options:{
					data: GlobalObj.Status,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUStatus'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUStatusDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BUStatusDesc.formatter=	function(value,row){
			return row.BUStatusDesc;
		}
	var BUPurposeDesc=$("#BuildingUnit").datagrid('getColumnOption','BUPurposeDesc');	
	BUPurposeDesc.editor={type: 'combobox',options:{
					data: GlobalObj.Purpose,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUPurpose'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUPurposeDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BUPurposeDesc.formatter=	function(value,row){
			return row.BUPurposeDesc;
		}
	var BUElectricCondDesc=$("#BuildingUnit").datagrid('getColumnOption','BUElectricCondDesc');	
	BUElectricCondDesc.editor={type: 'combobox',options:{
					data: GlobalObj.ElectricCond,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUElectricCond'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUElectricCondDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BUElectricCondDesc.formatter=	function(value,row){
			return row.BUElectricCondDesc;
		}
	var BUWaterCondDesc=$("#BuildingUnit").datagrid('getColumnOption','BUWaterCondDesc');	
	BUWaterCondDesc.editor={type: 'combobox',options:{
					data: GlobalObj.WaterCond,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUWaterCond'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUWaterCondDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BUWaterCondDesc.formatter=	function(value,row){
			return row.BUWaterCondDesc;
		}
	var BUSewageDisposalDesc=$("#BuildingUnit").datagrid('getColumnOption','BUSewageDisposalDesc');	
	BUSewageDisposalDesc.editor={type: 'combobox',options:{
					data: GlobalObj.SewageDisposal,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUSewageDisposal'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BUSewageDisposalDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BUSewageDisposalDesc.formatter=	function(value,row){
			return row.BUSewageDisposalDesc;
		}
	var BURadProtectDesc=$("#BuildingUnit").datagrid('getColumnOption','BURadProtectDesc');	
	BURadProtectDesc.editor={type: 'combobox',options:{
					data: GlobalObj.RadProtect,
                    valueField: "value",  
                    textField: "text", 
                    panelHeight:"auto",  
                    required: false,
                    onSelect:function(option){
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BURadProtect'});
						jQuery(ed.target).val(option.value);  //����ID
						var ed=jQuery("#BuildingUnit").datagrid('getEditor',{index:BuildUniteditIndex,field:'BURadProtectDesc'});
						jQuery(ed.target).combobox('setValue', option.text);
					}
		
		}};		//�����ӱ༭��
	BURadProtectDesc.formatter=	function(value,row){
			return row.BURadProtectDesc;
		}
}

function initCombox()
{
	///1:�� 2:�� 3:�� 4:�� 12:���� 14:���� 23������ 34:����
	$HUI.combobox('#BURoomFacing',{
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:[{id: '1',text: '�� '},{id: '2',text: '��'},{id: '3',text: '��'},{id: '4',text: '��'},{id: '12',text: '����'},{id: '14',text: '����'},{id: '23',text: '����'},{id: '34',text: '����'}]
	});	
	///0��δ�� 1������ 2��ԤԼ 3�������Ч
	$HUI.combobox('#BUStatus',{
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		data:[{id: '0',text: '���� '},{id: '1',text: '����'},{id: '2',text: 'ԤԼ'},{id: '3',text: 'δ��'}]
	});	
}

function initBuildingInfo()
{
	var FBuildingDR=getElementValue("FBuildingDR")
	var jsonData=tkMakeServerCall("web.DHCDT3D.BUSBuilding","GetOneBuilding",FBuildingDR);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	$("li").each(function(){
    	var key=$(this).attr('id');
    	if (typeof(key)=="undefined") return;
    	$("#"+key+" span").text(jsonData.Data[key]);	
	})
}


function DeleteGridData()
{
	var FRowID=getElementValue("FRowID")
	var FBuildingDR=getElementValue("FBuildingDR")
	var BuildUnitFlag=tkMakeServerCall("web.DHCDT3D.Floor","CheckBuildUnit",FRowID,FBuildingDR);
	if (BuildUnitFlag==1)
	{
		messageShow("confirm","","","��¥����ڷ�����Ϣ,�Ƿ�ȫ��ɾ��?","",function(){
				var result=tkMakeServerCall("web.DHCDT3D.Floor","DeleteData",FRowID,FBuildingDR);
				var SQLCODE=result.split("^")[0]
				if (SQLCODE==0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					ClearBuildUnit()
					$('#Floor').datagrid('reload');
					ClearFloor()
					$('#BuildingUnit').datagrid('reload');
					
					
				}
				else
			    {
					alertShow("������Ϣ:"+SQLCODE);
					return
			    }
			
			},"")
	}
	else
	{
		
				var result=tkMakeServerCall("web.DHCDT3D.Floor","DeleteData",FRowID,FBuildingDR);
				var SQLCODE=result.split("^")[0]
				if (SQLCODE==0)
				{
					$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					ClearBuildUnit()
					$('#Floor').datagrid('reload');
					
					
				}
				else
			    {
					alertShow("������Ϣ:"+SQLCODE);
					return
			    }
		
		
		}
	
}

function DeleteBuildUnitGridData()
{
	var dataList=""
	var rows = $('#BuildingUnit').datagrid('getChecked');
	if (rows!="")
	{
		$.each(rows, function(rowIndex, rowData){
			if (dataList=="")
			{ 
				dataList=rowData.BURowID;
			}
			 else dataList=dataList+getElementValue("SplitRowCode")+rowData.BURowID; 
		}); 
	}
	
	
	var result=tkMakeServerCall("web.DHCDT3D.BuildingUnit","DeleteData",dataList);
	var SQLCODE=result.split("^")[0]
	if (SQLCODE==0)
	{
		$.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
		ClearBuildUnit()
		$('#BuildingUnit').datagrid('reload');
		
		
	}
	else
    {
		alertShow("������Ϣ:"+SQLCODE);
		return
    }
	
}

function DeleteFloorGridData()
{
	var FRowID=getElementValue("FRowID")
	var result=tkMakeServerCall("web.DHCDT3D.Floor","DeleteData",FRowID);
	var SQLCODE=result.split("^")[0]
	if (SQLCODE==0)
	{
		$.messager.show({title: '��ʾ',msg: '����ɹ�'});
		ClearFloor()
		$('#Floor').datagrid('reload');
		
		
	}
	else
    {
		alertShow("������Ϣ:"+SQLCODE);
		return
    }
	
}

function setFloorIndex()
{
	var FBuildingDR=getElementValue("FBuildingDR")
	var FloorIndex=tkMakeServerCall("web.DHCDT3D.Floor","GetFloorIndex",FBuildingDR);
	setElement("FFloorIndex",(FloorIndex*1+1))
	
	
}
function cancelRequiredElements(vElementIDs)
{
	var ElementList=vElementIDs.split("^")
	for (var i=0;i<ElementList.length;i++)
	{
		setItemRequire(ElementList[i],false)
	}
}

function FindFloorGridData()
{
		$HUI.datagrid("#Floor",{   
		idField:'FRowID', //����   //add by lmm 2018-10-23
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCDT3D.Floor",
	        QueryName:"GetFloorDetail",
	        BuildingDR:getElementValue("FBuildingDR"),
	        FloorNo:getElementValue("FFloorNo"),
		    },
	});
	
}
function FindBuildUnitGridData()
{
		$HUI.datagrid("#BuildingUnit",{   
		idField:'BURowID', //����   //add by lmm 2018-10-23
	    border : false,
		striped : true,
	    cache: false,
	    fit:true,
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCDT3D.BuildingUnit",
	        QueryName:"GetBuildingUnitDetail",
	        BuildingDR:getElementValue("FBuildingDR"),
	        FloorIndex:getElementValue("FFloorIndex"),
	        DoorNo:getElementValue("BUDoorNo"),
	        Desc:getElementValue("BUDesc"),
	        UseLocDR:getElementValue("BUUseLocDR"),
		    },
	});
	
}
function onClickFloorRow(rowIndex,rowData)
{
	if (PreSelectedRowID!=rowData.TRowID)
	{
		setElement("FRowID",rowData.FRowID)
		setElement("FFloorNum",rowData.FFloorNum)
		setElement("FFloorIndex",rowData.FFloorIndex)
		setElement("BUFloorIndex",rowData.FFloorIndex)
		setElement("FFloorNo",rowData.FFloorNo)
		setElement("FBuildingArea",rowData.FBuildingArea)
		setElement("FUtilizationArea",rowData.FUtilizationArea)
		setElement("FHeight",rowData.FHeight)
		setElement("FPurpose",rowData.FPurposeID)
		PreSelectedRowID=rowData.FRowID
		FindBuildUnitGridData()
	}
	else
	{
		ClearFloor()
		PreSelectedRowID=""
		
	}
	
}
function onClickBuildUnitRow(rowIndex,rowData)
{
	if (PreSelectedBuildUnitRowID!=rowData.TRowID)
	{
		setElement("BURowID",rowData.BURowID)
		setElement("BUDesc",rowData.BUDesc)
		setElement("BUFloorIndex",rowData.BUFloorIndex)
		setElement("BUDoorNo",rowData.BUDoorNo)
		setElement("BUUseLocDR_DeptDesc",rowData.BUUseLoc)
		setElement("BUUnitType",rowData.BUUnitTypeID)
		setElement("BUStatus",rowData.BUStatusID)
		setElement("BUPurpose",rowData.BUPurposeID)
		setElement("BURoomFacing",rowData.BURoomFacingID)
		setElement("BUMinPeople",rowData.BUMinPeople)
		setElement("BUMaxPeople",rowData.BUMaxPeople)
		setElement("BUUseLocDR",rowData.BUUseLocDR)
		PreSelectedBuildUnitRowID=rowData.BURowID
		//FindBuildUnitGridData()
	}
	else
	{
		ClearBuildUnit()
		
	}	
	
}

function ClearBuildUnit()
{
	setElement("BURowID","")
	setElement("BUDesc","")
	setElement("BUDoorNo","")
	setElement("BUUseLocDR_DeptDesc","")
	setElement("BUUnitType","")
	setElement("BUStatus","")
	setElement("BUPurpose","")
	setElement("BURoomFacing","")
	setElement("BUMinPeople","")
	setElement("BUMaxPeople","")
	setElement("BUUseLocDR","")
	PreSelectedBuildUnitRowID=""
}
function ClearFloor()
{
	setElement("FRowID","")
	setElement("FFloorNum","")
	setElement("FFloorNo","")
	setElement("FBuildingArea","")
	setElement("FUtilizationArea","")
	setElement("FHeight","")
	setElement("FPurpose","")
	setElement("BUFloorIndex","")
	setFloorIndex()
	PreSelectedRowID=""
}

function AddGridData(userName)
{
	$('#Floor').datagrid('endEdit',editIndex);
	var dataList=""
	var rows = $('#Floor').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.ISLEquipName=="")
		{
			alertShow("��"+(i+1)+"�����ݲ���ȷ!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData
		}
	}
	if (dataList=="")
	{
		alertShow("�����ϸ����Ϊ��!");
		return;
	}
	var result=tkMakeServerCall("web.DHCDT3D.Floor","SaveFloor",dataList,userName);
	var SQLCODE=result.split("^")[0]
	if (SQLCODE==0)
	{
		$.messager.show({title: '��ʾ',msg: '����ɹ�'});
		
	if (userName=="User.DHCEQBUBuildingUnit")
	{
		ClearBuildUnit()
		$('#BuildingUnit').datagrid('reload');
	}
	else if (userName=="User.DHCEQBUFloor")
	{
		ClearFloor()
		$('#Floor').datagrid('reload');
	}
		
		
	}
	else
    {
		alertShow("������Ϣ:"+SQLCODE);
		return
    }
	
	
	
}

function AddBuildingUnitGridData(userName)
{
	$('#BuildingUnit').datagrid('endEdit',BuildUniteditIndex);
	
	var dataList=""
	var rows = $('#BuildingUnit').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.BUFloorIndex=="")
		{
			alertShow("��"+(i+1)+"��¥��������Ϊ��!")
			return "-1"
		}
		if (oneRow.BUDesc=="")
		{
			alertShow("��"+(i+1)+"�з�����������Ϊ��!")
			return "-1"
		}
		if (oneRow.BUDoorNo=="")
		{
			alertShow("��"+(i+1)+"�з���Ų���Ϊ��!")
			return "-1"
		}

		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData  //add by zx 2019-07-24 �ָ������޸�
		}
	}
	if (dataList=="")
	{
		alertShow("������ϸ����Ϊ��!");
		return;
	}
	var result=tkMakeServerCall("web.DHCDT3D.BuildingUnit","SaveBuildingUnit",dataList,userName);
	var SQLCODE=result.split("^")[0]
	if (SQLCODE==0)
	{
		$.messager.show({title: '��ʾ',msg: '����ɹ�'});
		
	if (userName=="User.DHCEQBUBuildingUnit")
	{
		ClearBuildUnit()
		$('#BuildingUnit').datagrid('reload');
	}
	else if (userName=="User.DHCEQBUFloor")
	{
		ClearFloor()
		$('#Floor').datagrid('reload');
	}
		
		
	}
	else
    {
		alertShow("������Ϣ:"+SQLCODE);
		return
    }
	
	
	
}

function setSelectValue(vElementID,item)
{
	if (vElementID=="BUUseLocDR_DeptDesc")
	{
		setElement("BUUseLocDR",item.TRowID)
	}
	else
	{
		setElement(vElementID+"DR",item.TRowID)
	}
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
var editIndex=undefined;
function onClickRow(index,rowData){
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#Floor').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#Floor').datagrid('getRows')[editIndex]);
		} else {
			$('#Floor').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

// ��������
function insertRow()
{
	if(BuildUniteditIndex>="0"){
		jQuery("#BuildingUnit").datagrid('endEdit', BuildUniteditIndex);//�����༭������֮ǰ�༭����
	}
    var rows = $("#BuildingUnit").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length

	if (newIndex>=0)
	{
		jQuery("#BuildingUnit").datagrid('insertRow', {index:newIndex,row:{
				BUFloorIndex:getElementValue("FFloorIndex"),TFlag:'',BURowID: '',BUUnitType:'',BUStatus: '',BUPurpose:'',BURoomFacing:'',BUBuildingDR: getElementValue("FBuildingDR"),BUDesc: '',BUDoorNo: '',BUUseLoc: '',BUUnitTypeDesc: '',BUPurposeDesc: '',BUStatusDesc: '',BUUseLocDR: '',BURoomFacingDesc: '',BUMinPeople: '',BUMaxPeople:''}  
			});
		BuildUniteditIndex=0;
		 		
	}
}

var BuildUniteditIndex=undefined;
function onClickBuildUnitRow(index,rowData)
{
	if (BuildUniteditIndex!=index) 
	{
		if (BuildUnitendEditing())
		{
			$('#BuildingUnit').datagrid('selectRow', index).datagrid('beginEdit', index);
			BuildUniteditIndex = index;
			modifyBeforeRow = $.extend({},$('#BuildingUnit').datagrid('getRows')[BuildUniteditIndex]);
		} else {
			$('#BuildingUnit').datagrid('selectRow', BuildUniteditIndex);
		}
	}
	else
	{
		BuildUnitendEditing();
	}}

function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#Floor').datagrid('validateRow', editIndex)){
			$('#Floor').datagrid('endEdit', editIndex);
    		var rows = $("#Floor").datagrid('getRows');
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function BuildUnitendEditing(){
		if (BuildUniteditIndex == undefined){return true}
		if ($('#BuildingUnit').datagrid('validateRow', BuildUniteditIndex)){
			$('#BuildingUnit').datagrid('endEdit', BuildUniteditIndex);
    		var rows = $("#BuildingUnit").datagrid('getRows');
			BuildUniteditIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function GetLoc(index,data)
{
	setElement("BUUseLocDR",data.TRowID)
	setElement("BUUseLoc",data.TName)
	//var rowData = $('#BuildingUnit').datagrid('getRows')[index];
	var rowData = $('#BuildingUnit').datagrid('getSelected');
	rowData.BUUseLoc=data.TName;
		var BUUseLoc = $('#BuildingUnit').datagrid('getEditor', {index:BuildUniteditIndex,field:'BUUseLoc'});
		$(BUUseLoc.target).combogrid("setValue",data.TName);
		$('#BuildingUnit').datagrid('endEdit',BuildUniteditIndex);
	rowData.BUUseLocDR=data.TRowID;
	rowData.BUUseLoc=data.TName;
	
	
}
function GetUnitType(index,data)
{
	//var rowData = $('#BuildingUnit').datagrid('getRows')[index];
	var rowData = $('#BuildingUnit').datagrid('getSelected');
		var BUUnitTypeDesc = $('#BuildingUnit').datagrid('getEditor', {index:BuildUniteditIndex,field:'BUUnitTypeDesc'});
		$(BUUnitTypeDesc.target).combogrid("setValue",data.TDesc);
		$('#BuildingUnit').datagrid('endEdit',BuildUniteditIndex);
	rowData.BUUnitType=data.TRowID;
	rowData.BUUnitTypeDesc=data.TDesc;

	
}
function GetPurpose(index,data)
{
	var rowData = $('#BuildingUnit').datagrid('getRows')[index];
	rowData.BUPurposeDesc=data.TDesc;
		var BUPurposeDesc = $('#BuildingUnit').datagrid('getEditor', {index:BuildUniteditIndex,field:'BUPurposeDesc'});
		$(BUPurposeDesc.target).combogrid("setValue",data.TDesc);
		$('#BuildingUnit').datagrid('endEdit',BuildUniteditIndex);
	rowData.BUPurpose=data.TRowID;
	
	
}
function GetFloorPurpose(index,data)
{
	var rowData = $('#Floor').datagrid('getRows')[index];
	rowData.FPurposeDesc=data.TDesc;
		var FPurposeDesc = $('#Floor').datagrid('getEditor', {index:editIndex,field:'FPurposeDesc'});
		$(FPurposeDesc.target).combogrid("setValue",data.TDesc);
		$('#Floor').datagrid('endEdit',editIndex);
	rowData.FPurpose=data.TRowID;
	
	
}
function checkboxFlagChange(TFlag,rowIndex)
{
	var row = jQuery('#BuildingUnit').datagrid('getRows')[rowIndex];
	if (row)
	{
		$.each(row,function(key,val){
			if (TFlag==key)
			{
				if (((val=="N")||val=="")) row.TFlag="Y"
				else row.TFlag="N"
			}
		})
	}
}

function SearchHander(value,name)
{

	$HUI.datagrid("#BuildingUnit",{   
	idField:'BURowID', //����   //add by lmm 2018-10-23
    border : false,
	striped : true,
    cache: false,
    fit:true,
    url:$URL, 
    queryParams:{
        ClassName:"web.DHCDT3D.BuildingUnit",
        QueryName:"GetBuildingUnitDetail",
        AllDesc:value,
	    },
	});


	
}
