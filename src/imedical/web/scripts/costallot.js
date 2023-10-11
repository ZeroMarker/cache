/// ����: web.DHCEQ.EM.BUSCostAllot
/// ����: �۾ɷ�̯�෽��
/// ��д�ߣ�ZY
/// ��д����: 2022-4-15
/// ��Ʒ�飺�豸����

var editFlag="undefined";
var SelectRowID="";
var CARowID=getElementValue("CARowID"); 
var CATypes=getElementValue("CATypes");
var CAHold2=getElementValue("CAHold2");
var Status=getElementValue("Status");
var ReadOnly=getElementValue("ReadOnly");
var CAHold1=parseFloat(getElementValue("CAHold1"));
var Columns=getCurColumnsInfo('EM.G.CostAllot','','','')
///modified by zy0303 20220614
var ObjSources=new Array();

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage("StoreMove"); //��ȡ����ҵ����Ϣ
    initCAAllotType();
    setElement("CAAllotType",0)
    
    //initLookUp();
	defindTitleStyle(); 
    initButton();
    initButtonWidth();
	$HUI.datagrid("#tDHCEQCostAllot",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSCostAllot",
	        	QueryName:"CostAllot",
				CARowID:CARowID,
			},
			fit:true,
			border:false,	//modified zy ZY0215 2020-04-01
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			fitColumns : true,    //add by lmm 2020-06-04
			toolbar:[{
				iconCls:'icon-add',
				text:'����',
				id:'add',
				handler:function(){insertRow();}
			},
			{
                iconCls: 'icon-cancel',
				text:'ɾ��',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    
				if (editFlag!=rowIndex) 
				{
					if (endEditing())
					{
						$('#tDHCEQCostAllot').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
						editFlag = rowIndex;
						modifyBeforeRow = $.extend({},$('#tDHCEQCostAllot').datagrid('getRows')[editFlag]);
						bindGridEvent();  //�༭�м�����Ӧ
					} else {
						$('#tDHCEQCostAllot').datagrid('selectRow', editFlag);
					}
				}
				else
				{
					endEditing();
				}
		    
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			},
			onLoadSuccess:function(){
				var rows = $('#tDHCEQCostAllot').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
					ObjSources[i]=new SourceInfo(rows[i].CALAllotLocDR);
			    }
			}
	});
	var ReadOnly=getElementValue("ReadOnly")
	if ((ReadOnly==1)||(ReadOnly=="Y"))
	{
		$("#add").linkbutton("disable");
		$("#delete").linkbutton("disable");
		$("#BSave").linkbutton("disable");
		$("#BDelete").linkbutton("disable");
	}
}

function endEditing()
{
	if (editFlag == undefined){return true}
	if ($('#tDHCEQCostAllot').datagrid('validateRow', editFlag)){
		$('#tDHCEQCostAllot').datagrid('endEdit', editFlag);
		editFlag = undefined;
		return true;
	} else {
		return false;
	}
}

function initCAAllotType()
{
	var data=[{
				id: '0',
				text: '�̶�����(%)'
			}
			/*,{
				id: '1',
				text: '������'
			},{
				id: '2',
				text: '�������(M2)'
			},{
				id: '3',
				text: '��������(��)'
			},{
				id: '4',
				text: '���Ҵ�λ(��)'
			},{
				id: '5',
				text: '��������(Ԫ)'
			},{
				id: '6',
				text: '�̶�ֵ'
			}*/]
	if (CATypes==2)	data=[{id: '0',text: '�̶�����(%)'},{	id: '6',text: '�̶�ֵ'}] 
	var CAAllotType = $HUI.combobox('#CAAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:data
	});
	
}
function bindGridEvent()
{
	if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQCostAllot");
        var invRateEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
        var invValueEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
        // ����  �� �뿪�¼�
        $(invRateEdt.target).bind("blur",function(){
            var CALAllotPercentNum=parseFloat($(invRateEdt.target).val());
	        var CALWorkLoadNum=CAHold1*(CALAllotPercentNum/100)
			CALWorkLoadNum=CALWorkLoadNum.toFixed(2)
	        
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALWorkLoadNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
			$(CALWorkLoadNumEditor.target).val(CALWorkLoadNum);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
        $(invValueEdt.target).bind("blur",function(){
            var CALWorkLoadNum=parseFloat($(invValueEdt.target).val());
	        //var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	        var CALAllotPercentNum=CALWorkLoadNum*100/CAHold1;
			CALAllotPercentNum=CALAllotPercentNum.toFixed(2)
			
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALAllotPercentNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
			$(CALAllotPercentNumEditor.target).val(CALAllotPercentNum);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
// ��������
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQCostAllot").datagrid('getRows');
    var lastIndex=rows.length-1
    if (lastIndex==-1) lastIndex=0
    var newIndex=rows.length
	$("#tDHCEQCostAllot").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}

function DeleteData()
{
	//add by ZY0303 2659195 �޸�����ʱ����ɾ����һ��bug ZX0067
	var graidLength=$('#tDHCEQCostAllot').datagrid('getRows').length;
	if(graidLength<2)
	{
		messageShow("alert",'info',"��ʾ","��ǰ�в���ɾ��!");
		return;
	}
	if (editFlag != undefined)
	{
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
		$('#tDHCEQCostAllot').datagrid('deleteRow',editFlag);
	} 
	else
	{
		messageShow("alert",'info',"��ʾ","��ѡ��һ��!");
	}
}
function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
	var data=getInputList();
	var CAAllotType=getElementValue("CAAllotType");
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#tDHCEQCostAllot').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.CALAllotLocDR=="")
		{
			alertShow("��"+(i+1)+"�п���ID����Ϊ��!")
			return "-1"
		}
		if ((oneRow.CALAllotPercentNum=="")&&(CAAllotType!="6"))
		{
			alertShow("��"+(i+1)+"�з�̯�ٷֱȲ���Ϊ��!")
			return "-1"
		}
		if (oneRow.CALWorkLoadNum=="")
		{
			alertShow("��"+(i+1)+"�з�̯��Ȳ���Ϊ��!")
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
		alertShow("��̯��ϸ����Ϊ��!");
		return;
	}
	disableElement("BSave",true)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&CARowID="+jsonData.Data+"&Status="+Status+"&ReadOnly="+ReadOnly+"&CATypes="+CATypes+"&CAHold2="+CAHold2;
		url="dhceq.em.costallot.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    disableElement("BSave",false)	//add by csj 2020-03-10 ����ʧ�ܺ�����
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
function BDelete_Clicked()
{
	if (CARowID=="")
	{
		alertShow("û�з�̯������Ҫɾ��!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",CARowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var val="&CARowID="+jsonData.Data+"&Status="+Status+"&ReadOnly="+ReadOnly+"&CATypes="+CATypes+"&CAHold2="+CAHold2;
		url="dhceq.em.costallot.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
//hisui.common.js���������Ҫ
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

function GetUseLoc(index,data)
{
	///modified by zy0303 20220614
	var Length=ObjSources.length
	for (var i=0;i<Length;i++)
	{
		if ((ObjSources[i].SourceID==data.TRowID)&&(editFlag!=i))
		{
			var RowNo=i+1
			alertShow("ѡ��Ŀ������"+RowNo+"���ظ�!")
			return;
		}
	}
	
	var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	rowData.CALAllotLocDR=data.TRowID;
	ObjSources[index]=new SourceInfo(rowData.CALAllotLocDR);
	
	///modified by ZY02264 20210521
	var editor = $('#tDHCEQCostAllot').datagrid('getEditor',{index:editFlag,field:'CALAllotLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
	// modified by ZY0306 2659235  20220704
	//$('#tDHCEQCostAllot').datagrid('selectRow', editFlag).datagrid('beginEdit', editFlag);	//modified by ZY
	//$("#CLLAction"+"z"+editFlag).hide()
}

///add by zy0303 20220614
function SourceInfo(SourceID)
{
	this.SourceID=SourceID;
}
