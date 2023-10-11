///modified by ZY0247  2020-12-14
var SelectRowID="";
var Columns=getCurColumnsInfo('BA.G.BenefitEquipList.EquipListFind','','','')
var editIndex=undefined;

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	initUserInfo();
    initMessage("ba"); //��ȡ����ҵ����Ϣ
    initLookUp();
	defindTitleStyle(); 
  	initButton();
    initButtonWidth();
    initPage();//��ͨ�ð�ť��ʼ��  add by wy 2020-6-4 
	$HUI.datagrid("#DHCEQBenefitEquipListFind",{   
	    url:$URL, 
	    queryParams:{
	        	ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",
	        	QueryName:"GetBenefitEquipList",
				vItemDR:getElementValue("MasterItemDR"),
				vNo:getElementValue("No"),
				vUseLocDR:getElementValue("UseLocDR"),
				vFromOriginalFee:getElementValue("FromOriginalFee"),
				vToOriginalFee:getElementValue("ToOriginalFee"),
				QXType:getElementValue("QXType"),
				CLOCID:session['LOGON.CTLOCID']
			},
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			fit:true,
			border:false,
			columns:Columns,
			toolbar:[
				{
					id:'add',     
					iconCls:'icon-add',
					text:'����',
					handler:function(){BEquip_Clicked()}
				}/*,
				{					//czf 2021-03-09 1789983
					id:'save',     
					iconCls:'icon-save',
					text:'����',
					handler:function(){BSave_Clicked()}
				}*/
			],
			pagination:true,
			pageSize:25,
			pageNumber:1,
			pageList:[25,50,75,100],
			onClickRow:function(rowIndex,rowData){
				SelectRowHandler(rowIndex,rowData);
			}
	});}
function initPage() 
{
	/*
	if (jQuery("#BEquip").length>0)
	{
		jQuery("#BEquip").on("click", BEquip_Clicked);
	}
	*/
}
//add by wy 2020-6-25 �豸�嵥
function BEquip_Clicked()
{
	var para="&ReadOnly="+"&QXType="+getElementValue("QXType")+"&UseLocDR="	
	var url="dhceq.ba.equipfind.csp?"+para;
	//modified by ZY0255 20210301
	showWindow(url,"�豸�嵥","","","icon-w-paper","modal","","","large",BFind_Clicked); 
}
//add by wy 2020-6-25 ����
function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQBenefitEquipListFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",
	        	QueryName:"GetBenefitEquipList",
				vItemDR:getElementValue("MasterItemDR"),
				vNo:getElementValue("No"),
				vUseLocDR:getElementValue("UseLocDR"),
				vFromOriginalFee:getElementValue("FromOriginalFee"),
				vToOriginalFee:getElementValue("ToOriginalFee"),
				QXType:getElementValue("QXType"),
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
//add by wy 2020-8-5 ��ѯ������ֵ�����
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(elementID)
{	
	setElement(elementID+"DR","")
}

function clearHold1()
{
	var rowData = $('#DHCEQBenefitEquipListFind').datagrid('getSelected');
	rowData.THold1="";
	$('#DHCEQBenefitEquipListFind').datagrid('endEdit',editIndex);
	$('#DHCEQBenefitEquipListFind').datagrid('beginEdit',editIndex);
}

//czf 2021-03-09 1789983
function BSave_Clicked()
{
	if (editIndex != undefined){ $('#DHCEQBenefitEquipListFind').datagrid('endEdit', editIndex);}
	var dataList="";
	var rows = $('#DHCEQBenefitEquipListFind').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i];
		var TRowID=oneRow.TRowID;
		var THold1=oneRow.THold1;
		if (dataList=="") dataList=TRowID+"^"+THold1;
		else dataList=dataList+"&"+TRowID+"^"+THold1;
	}
	
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveDataList",dataList,"0");
	jsonData=JSON.parse(jsonData);
	if (jsonData.SQLCODE==0)
	{
		BFind_Clicked();
	}
	else
    {
		messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
		return
    }
}

function getLoc(editIndex,data)
{
	var rowData = $('#DHCEQBenefitEquipListFind').datagrid('getSelected');
	rowData.THold1=data.TRowID;
	var THold1DescEdt = $('#DHCEQBenefitEquipListFind').datagrid('getEditor', {index:editIndex,field:'THold1_DeptDesc'});
	$(THold1DescEdt.target).combogrid("setValue",data.TName);
	$('#DHCEQBenefitEquipListFind').datagrid('endEdit',editIndex);
}

//czf 1880419 2021-07-08
//ִ�п��ҵ���
function BExecuteLoc(editIndex)
{
	var rowData =  $("#DHCEQBenefitEquipListFind").datagrid("getRows")[editIndex];
	var TRowID=rowData.TRowID;
    var THold1=rowData.THold1;
    var THold1DeptDesc=rowData.THold1_DeptDesc;
    $HUI.dialog('#UpdateBAEQWin', {
		width: 300,
		height: 200,
		modal:true,
		title: '�޸��豸ִ�п���',
		buttons:[{
			text:'����',
			handler:function(){
				var dataList=TRowID+"^"+$("#BELHold1_CTLOCDesc").combogrid('getValues');
				var jsonData=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveDataList",dataList,"0");
				jsonData=JSON.parse(jsonData);
				if (jsonData.SQLCODE==0)
				{
					$HUI.dialog("#UpdateBAEQWin").close();
					BFind_Clicked();
				}
				else
			    {
					messageShow('alert','error','��ʾ',"������Ϣ:"+jsonData.Data);
					return
			    }
			}
		},{
			text:'�ر�',
			handler:function(){
				$HUI.dialog("#UpdateBAEQWin").close();
			}
		}],
		onOpen: function(){
			//ִ�п��ҳ�ʼ��
			initCurTreeLookUp();
			if (THold1=="") THold1=[];
			else THold1=THold1.split(",");
			$("#BELHold1_CTLOCDesc").combogrid("setValues",THold1);
			$("#BELHold1_CTLOCDesc").combogrid("setText",THold1DeptDesc);
		}
	}).open();
}

//czf 1880419 2021-07-08
//��ʼ������combogrid���ɶ�ѡ
function initCurTreeLookUp()
{
	CurTreeCombo=$HUI.combogrid('#BELHold1_CTLOCDesc',{
		delay: 500,
		mode: 'remote',
		pagination:true,
		lazy:true,
		showPageList:false,
		showRefresh:false,
		displayMsg:"��ǰ:{from}~{to},��{total}��",
		panelWidth: 500,
		paneiHeight:600,
		multiple: true,
		rownumbers: true,           //���
        collapsible: false,         //�Ƿ���۵���
        singleSelect : false,
        checkOnSelect :true,
		fitColumns: true,
		url: $URL,
		idField: 'TRowID',
		textField: 'TName',
		queryParams:{
			ClassName: 'web.DHCEQ.Plat.LIBFind',
			QueryName: 'GetEQLoc',
			Type:"",
			LocDesc:$('#BELHold1_CTLOCDesc').val(),
			vgroupid:"",
			LocType:"",
			notUseFlag:"",
			UserID:"",
			CurHosptailID:"",
			CTLocAllFlag:""
		},
		columns: [[
			{field:'TChk',checkbox:true},
			{field:'TRowID',title:'RowID',width:30,hidden:true},
			{field:'TName',title:'����',width:150},
			{field:'TCode',title:'����',width:120}
		]],
		onSelect:function(index,rowData){
			//setElement("BELHold1",$('#SelectLoc').combogrid('getValues'))
		}
	})
	$('#BELHold1_CTLOCDesc').combogrid('textbox').unbind()//�Ƚ�������¼���Ҫ������������Ҳ���ƥ����س�ʱ��������ݻᱻ���
	$('#BELHold1_CTLOCDesc').combogrid('textbox').keydown(function (e) {
		if (e.keyCode == 13) {
			var keyValue = $('#BELHold1_CTLOCDesc').combogrid('textbox').val();
			var queryParams = $('#BELHold1_CTLOCDesc').combogrid("grid").datagrid('options').queryParams;
			queryParams.LocDesc = keyValue;
			$('#BELHold1_CTLOCDesc').combogrid("grid").datagrid("reload");	//���¼���
			$('#BELHold1_CTLOCDesc').combogrid("setValue", keyValue);
			$('#BELHold1_CTLOCDesc').combo('showPanel');
		}
	});
	$('#BELHold1_CTLOCDesc').combogrid('textbox').change(function(){
		SetElement("#BELHold1","");
	})
}

function SelectRowHandler(index,rowData)
{
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQBenefitEquipListFind').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQBenefitEquipListFind').datagrid('getRows')[editIndex]);
			//bindGridEvent();  //�༭�м�����Ӧ
		} else {
			$('#DHCEQBenefitEquipListFind').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}

function endEditing()
{
	if (editIndex == undefined){return true}
	if ($('#DHCEQBenefitEquipListFind').datagrid('validateRow', editIndex)){
		$('#DHCEQBenefitEquipListFind').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
///add by ZY0269 20210615
function reloadGrid()
{
	$HUI.datagrid("#DHCEQBenefitEquipListFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",
	        	QueryName:"GetBenefitEquipList",
				vItemDR:getElementValue("MasterItemDR"),
				vNo:getElementValue("No"),
				vUseLocDR:getElementValue("UseLocDR"),
				vFromOriginalFee:getElementValue("FromOriginalFee"),
				vToOriginalFee:getElementValue("ToOriginalFee"),
				QXType:getElementValue("QXType"),
		},
		rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
		singleSelect:true,
		fit:true,
		border:false,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100]
	});
}
///add by ZY0301 20220523
function getParam(ID)
{
	
}