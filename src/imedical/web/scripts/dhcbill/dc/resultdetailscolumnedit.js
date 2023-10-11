/**
 * FileName: dhcbill\dc\resultdetailscolumnedit.js
 * Author: zhangjb
 * Date: 2022-08-24
 * Description: ���ݺ˲�����ϸ����
 */

var GV = {
	CKRDCLASSNAME:"BILL.DC.BL.CheckResultDetCtl"
};
var ColData=[];
var PageNum="";
var ChoselRow = -1;
$(function() {
	$("#ColshowTip").switchbox("setValue",false);
	GetLoadDataDialog('1');
});

function init_ckDetDG(){
	$HUI.datagrid("#ColList", {
		fit: true,
		border: false,
		singleSelect: true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pageSize: 100,
		pageList: [30, 50, 100, 300, 500],
		pagination: false,
		pageNumber: 0,
		sortName:'ConDesc',
		remoteSort:false,
		//toolbar: '#gridBar',
		//toolbar: '#dgTB',
		// IndicatorId,IndicatorCode,IndicatorName,CheckMode,CheckStartDate,CheckStartTime,CheckEndDate,CheckEndTime,CheckFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,CheckBatch,ExceptionNum
		columns: [[
			{field:'DicType',title:'�ֵ�����',width:80,hidden:true},
			{field:'DicCode',title:'����',width:80,hidden:true},
			{field:'DicDesc',title:'����',hidden:true},
			{field:'DicDemo',title:'������',width:200,showTip: true,formatter:function(val){
				return JSON.parse(val).title;	
			} },
			{field:'ConCode',title:'formatter',width:200,showTip: true,hidden:true},
			{field:'ConDesc',title:'������',width:80,sortable:true,sortOrder:'asc',
				sorter:function(a,b){
				var num1=parseFloat(a);
				var num2=parseFloat(b);
				return (num1>num2?1:-1);
			}
			},
			{field:'ConDemo',title:'���ձ�ע',width:150,hidden:true},
			{field:'ActiveFlag',title:'�Ƿ�����',width:50,hidden:true,
			formatter: function (value, row, index) {
				return (value == "Y") ? "<font color='#21ba45'>��</font>" : "<font color='#f16e57'>��</font>";}},
			{field:'HospDr',title:'Ժ��',width:50,hidden:true},
			{field:'CRTER',title:'������',width:50,hidden:true},
			{field:'CRTEDATE',title:'��������',width:50,hidden:true},
			{field:'CRTETIME',title:'����ʱ��',width:50,hidden:true},
			{field:'UPDTID',title:'������',width:50,hidden:true},
			{field:'UPDTDATE',title:'��������',width:50,hidden:true},
			{field:'UPDTTIME',title:'����ʱ��',width:50,hidden:true},
			{field:'Rowid',title:'Rowid',width:10,hidden:true}
		]],
		onBeforeLoad: function(param) {
			$.cm({
				ClassName: "BILL.DC.BL.DicDataCtl",
				QueryName: 'QueryInfo',
				ExpStr:"",
				HospID : "2",
				KeyCode:"",
				PDicType:"CKDETCol"
					
			},function(txtData){
				$('#ColList').datagrid('loadData',txtData); 
			
			});   
		},
	 	onLoadSuccess: function(data) {
		 	$(this).datagrid('enableDnd');
		 	//data.total=GV.Total;
		},
		onDblClickRow: function(rowIndex, rowData){
			//ShowColEdit();
		},
		onDrop: function () {
             var appIdStr = '';
             var rows = $('#ColList').datagrid('getRows');
             var savecode;
             $.each(rows,function(index,val){
	         	var DicType = val.DicType;
				var DicCode = val.DicCode;
				var DicDesc = val.DicDesc;
				var DicDemo = val.DicDemo;
				var ConDesc = index+1;
				var ConDemo = val.ConDemo;
				var ActiveFlag = val.ActiveFlag;
				var HospDr =val.HospDr;
				var Rowid = val.Rowid;
				var ConCode = val.ConCode;
				var selRowid = val.Rowid;
				var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
				saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
				saveinfo=saveinfo.replace(/��������Ϣ/g,"")
				///alert(saveinfo)
				savecode=tkMakeServerCall("BILL.DC.BL.DicDataCtl","Save",saveinfo,session['LOGON.USERID'])   
				
	         });
	         if(savecode.split('^')[0]>0){	
	         	$('#ColList').datagrid('reload'); 
				$.messager.popover({
					msg: '����ɹ�',
					type: 'success',
					timeout: 1500, 		//0���Զ��رա�3000s
					showType: 'slide'  //show,fade,slide
				});  
			}else{
				$.messager.popover({
					msg: '����ʧ��',
					type: 'error',
					timeout: 1500, 		//0���Զ��رա�3000s
					showType: 'slide'  //show,fade,slide
				});  
			}
		},
		onSelect: function(rowIndex, rowData) {
			if(ChoselRow==rowIndex){
		        ChoselRow=-1;
		        $(this).datagrid('unselectRow',rowIndex);
		        ClearRightEdit();
		    }else{
			    ChoselRow=rowIndex
			    ShowRightEdit();
			} 
		} 
	});
	//setTimeout$('#ckDet').datagrid('getPager').data("pagination").options.total=999;
}

//����ָ����ϸ����
function GetLoadDataDialog(){
	init_ckDetDG();
	$.cm({
			ClassName: "BILL.DC.BL.DicDataCtl",
			QueryName: 'QueryInfo',
			ExpStr:"",
			HospID : "2",
			KeyCode:"",
			PDicType:"CKDETCol"
	
		},function(txtData){
			$('#ColList').datagrid('loadData',txtData); 
	});   
}

function ChangerHendid(a,b){
	console.log(a);
    console.log(b);
}

//��д�ұ߿�
function ShowRightEdit(){
	var data=$('#ColList').datagrid('getSelected')
	var dataobj=$.parseJSON(data.DicDemo);
	if (dataobj.hidden!=undefined)
	{
		if(dataobj.hidden==true)
		{$("#Colhidden").switchbox("setValue",false);}
		else
		{$("#Colhidden").switchbox("setValue",true);}
	}
	else
	{
		$("#Colhidden").switchbox("setValue",true);
	}
	if (dataobj.showTip!=undefined)
	{
		$("#ColshowTip").switchbox("setValue",dataobj.showTip);
	}
	else
	{
		$("#ColshowTip").switchbox("setValue",false);
	}
	setValueById('ColTitle',dataobj.title);
	setValueById('Colfield',dataobj.field);
	$("#Colfield").validatebox({disabled:true});
	setValueById('ColWidth',dataobj.width);
	setValueById('ColConCode',data.ConCode);
}
//����ұ߿�
function ClearRightEdit(){
	$('#ColList').datagrid('unselectAll');
	setValueById('ColTitle',"");
	$("#ColTitle").validatebox({disabled:false});
	setValueById('Colfield',"");
	$("#Colfield").validatebox({disabled:false});
	setValueById('ColWidth',"");
	setValueById('ColConCode',"");
	$("#Colhidden").switchbox("setValue",true);
	$("#ColshowTip").switchbox("setValue",false);
}
//�����ұ߿�����
function SaveRightEdit(type){
	
    var DicType = "";
	var DicCode = "";
	var DicDesc = "";
	var ConDesc = "";
	var ConDemo = "";
	var ActiveFlag = "";
	var HospDr ="";
	if (getValueById('Colfield')==""||getValueById('ColTitle')=="")
	{
		$.messager.alert('��ʾ',"����������Ƿ���д��",'info');
		return;
	}
	//�޸�
	if(type=="0")
	{
		var data=$('#ColList').datagrid('getSelected')
		if(data==undefined)
		{
			$.messager.alert('��ʾ',"��ѡ�����һ�������ٽ����޸ġ�",'info');
			return;
		}
	    DicType = data.DicType;
		DicCode = data.DicCode;
		DicDesc = data.DicDesc;
		ConDesc = data.ConDesc;
		ConDemo = data.ConDemo;
		ActiveFlag = data.ActiveFlag;
		HospDr =data.HospDr;
		selRowid = data.Rowid;
	}
	//����
	if(type=="1")
	{
		var data=$('#ColList').datagrid('getSelected')
		if(data!=undefined)
		{
			$.messager.alert('��ʾ',"���ѡ��״̬�������������������ٱ༭��",'info');
			return;
		}
		DicType="CKDETCol";
		DicCode=getValueById('Colfield');
		DicDesc=getValueById('ColTitle');
		ConDesc=$('#ColList').datagrid('getData').total+1;
		ConDemo="USER";
		ActiveFlag="Y";
		HospDr=session['LOGON.HOSPID'];
		selRowid="";
	}
	var Colobj={};
	Colobj.field=getValueById('Colfield');
	Colobj.title=getValueById('ColTitle');
	Colobj.width=getValueById('ColWidth');
	if(Colobj.field=="ck")//��˸�ѡ��
	{
		Colobj.align="center";
		Colobj.checkbox=true;
	}
	Colobj.hidden=$("#Colhidden").switchbox("getValue")==true?undefined:true;
	Colobj.showTip=$("#ColshowTip").switchbox("getValue");
	//Colobj.formatter=getValueById('ColConCode'); 
	var DicDemo = JSON.stringify(Colobj);  //������
	var ConCode = getValueById('ColConCode');  //formatter
	var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.DC.BL.DicDataCtl","Save",saveinfo,session['LOGON.USERID']) 
	if(savecode.split('^')[0]>0){	
 		$('#ColList').datagrid('reload'); 
 		ClearRightEdit();
 		$.messager.popover({
			msg: '����ɹ�',
			type: 'success',
			timeout: 1500, 		//0���Զ��رա�3000s
			showType: 'slide'  //show,fade,slide
		}); 
	} 
	else
	{
		$.messager.popover({
			msg: '����ʧ��',
			type: 'error',
			timeout: 1500, 		//0���Զ��رա�3000s
			showType: 'slide'  //show,fade,slide
		});  
	}
	
}

//�򿪱༭����
function ShowColEdit(){
	var data=$('#ColList').datagrid('getSelected')
	
    $HUI.switchbox('#Colhidden',{
        onText:'��',
        offText:'��',
        onClass:'primary',
        offClass:'gray',
        onSwitchChange:function(e,obj){
            console.log(e);
            console.log(obj);
        }
    });
	setValueById('EditDicDemo',data.DicDemo);
	setValueById('EditConCode',data.ConCode);
	$('#diagApp').dialog({
             title: '�༭',
             iconCls: 'icon-w-edit',
             modal: true
         }).dialog('open');
   
}

function Save(){
	var data=$('#ColList').datagrid('getSelected')
    var DicType = data.DicType;
	var DicCode = data.DicCode;
	var DicDesc = data.DicDesc;
	var DicDemo = getValueById('EditDicDemo');  //������
	var ConDesc = data.ConDesc;
	var ConDemo = data.ConDemo;
	var ActiveFlag = data.ActiveFlag;
	var HospDr =data.HospDr;
	var Rowid = data.Rowid;
	var ConCode = getValueById('EditConCode');  //formatter
	var selRowid = data.Rowid;
	var saveinfo=selRowid+"^"+DicCode+"^"+DicDesc+"^"+DicDemo+"^"+ConDesc+"^"+ConDemo+"^"+ActiveFlag+"^"+HospDr;
	saveinfo = saveinfo + "^^^^^^^" + ConCode + "^" + DicType;
	saveinfo=saveinfo.replace(/��������Ϣ/g,"")
	///alert(saveinfo)
	var savecode=tkMakeServerCall("BILL.DC.BL.DicDataCtl","Save",saveinfo,session['LOGON.USERID']) 
	if(savecode.split('^')[0]>0){	
 		$('#ColList').datagrid('reload'); 
 		$.messager.popover({
			msg: '����ɹ�',
			type: 'success',
			timeout: 1500, 		//0���Զ��رա�3000s
			showType: 'slide'  //show,fade,slide
		}); 
	} 
	else
	{
		$.messager.popover({
			msg: '����ʧ��',
			type: 'error',
			timeout: 1500, 		//0���Զ��رա�3000s
			showType: 'slide'  //show,fade,slide
		});  
	}
	$('#diagApp').dialog('close'); 
}

function CloseThisWin()
{
	$.messager.confirm('��ʾ','ȷ���˹رս���ô��',function(r){
		if(r){
			websys_showModal('close');
		}
	}); 
}

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
	$('#' + gridid).datagrid('unselectAll');
	$('#' + gridid).datagrid('clearChecked');
}

