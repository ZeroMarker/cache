/*
ģ��:סԺҩ��
��ģ��:סԺҩ��-��ҩ
createdate:2016-05-04
creator:yunhaibao
*/
var commonInPhaUrl = "DHCST.INPHA.ACTION.csp";
var commonOutPhaUrl="DHCST.OUTPHA.ACTION.csp";
var gLocId=session['LOGON.CTLOCID'];
var gUserId=session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var hisPatNoLen=0;
var The_Time;
var dispCatPid=0;
var dispCatArr;
var wardIdStr="";
var paramStr=""; //סԺҩ������
var phaLocDispCat=""; //��ҩ����Ӧ�����
var CurKFlag=""; //�����л���ǩ����onbeforeunload�����global����
$(function(){
	InitComputerMac();
	InitTitle();
	InitPhaLoc();
	InitWardList();
	InitLocGroup();
	InitDispWardList(); //��ʼ����ҩ�����б�
	InitDispAdmList(); //��ʼ�����ǼǺŵ��б�
	InitDispList(); //��ʼ����ҩ��ϸ
	InitDispTotalList(); //��ʼ����ҩ����
	InitCondition();
	$('#textInci').on('keypress',function(event){
	 	if(event.keyCode == "13")    
	 	{
		 var input=$.trim($("#textInci").val());
		 if (input!="")
		 {
			var mydiv = new IncItmDivWindow($("#textInci"), input,getDrugList);
            mydiv.init();
		 }else{
			$("#textInciRowId").val("");	
		 }	
	 }
	});
	$('#patNo').on('keypress',function(event){
        if(event.keyCode == "13"){
			var patno=$.trim($("#patNo").val());
			$("#patInfo").text("")
			if (patno!=""){
				SetPatInfo(patno);
			}
        }
    });
    $('#checkedTime').on('click',function(){
		$("input[type=checkbox][id=checkedTime]").each(function(){
			if($('#'+this.id).is(':checked')){
				The_Time=setInterval("QueryDispWardList();", 30000);
			}
			else{
				clearInterval(The_Time) 
			}
		})
    });
    $('#checkedLocal').on('click',function(){
		$("input[type=checkbox][id=checkedLocal]").each(function(){
			SetLocalConfig(this.id)
		})
    });
    $("input[type=checkbox][name=checkedCondition]").on('click',function(){
		SetConditionCheck(this.id)		
    });
	$('#btnFind').on("click",QueryDispWardList); 
	$('#btnFindSum').on("click",QuerySelectDispList); 
	$('#btnRefuse').on("click",btnRefuseHandler); 
	$('#btnDisp').on("click",btnDispHandler);
	$('#btnCollect').on("click",function(){
		CollectHandler();
	}); 
	$('#btnFindDisped').on("click",function(){
		var lnk="dhcpha.dispquery.csp";
   		window.open(lnk,"_target","height=600,width=900,menubar=no,status=yes,toolbar=no,resizable=yes") ;
	});
	$('#tabsone').tabs({   
      border:false,   
      onSelect:function(title){   
          if (title=="��ҩ����"){
		  	RefTabOne();
	      }
	      CurKFlag=0;
      }   
  	});  
	$('#tabstwo').tabs({   
      border:false,   
      onSelect:function(title){   
		  RefTabTwo();
		  ClearDispGrid();
      }   
  	}); 
});
function InitPhaLoc(){
	$('#phaLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetStockPhlocDs&groupId='+gGroupId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#phaLoc').combobox('getData');
            if (data.length > 0) {
                  $('#phaLoc').combobox('select', gLocId);
              }            
	    },
	    onSelect:function(){
		    var selectLoc=$('#phaLoc').combobox("getValue")
			var newcolumns=getPhaLocDispType(selectLoc);
	        var options = $("#dispwardgrid").datagrid("options");                   //ȡ����ǰdatagrid������     
	        options.columns =[newcolumns];    
	        options.queryParams.params = "";                                            
	        $("#dispwardgrid").datagrid(options);                                        
	        $("#dispwardgrid").datagrid("reload");
	        $('#locGroup').combobox('reload',commonInPhaUrl+'?action=GetLocGroupDs&locId='+selectLoc); 
	        GetPhaLocConfig(selectLoc);  
		}
	});
}
function InitWardList()
{
	$('#wardLoc').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetWardLocDs',  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitLocGroup()
{
	$('#locGroup').combobox({  
		width:225,
		panelWidth: 225,
		url:commonInPhaUrl+'?action=GetLocGroupDs&locId='+gLocId,  
		valueField:'RowId',  
		textField:'Desc',
		onLoadSuccess: function(){         
	    }
	});

}
function InitDispWardList(){
	//����columns
	var newcolumns=getPhaLocDispType(gLocId)
	//����datagrid
	$('#dispwardgrid').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:[newcolumns],
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:30,  // ÿҳ��ʾ�ļ�¼����
		pageList:[30,50,100],   // ��������ÿҳ��¼�������б�
		//pagination:true,
		onLoadSuccess: function(){
 	
	    },
		onClickCell: function (rowIndex, field, value) {
			if (field!="TSelect"){
				if (field!="TWard"){
					var tmpcheck=""
					if (value=="Y"){tmpcheck="N"}
					else{tmpcheck="Y"}
					// �õ�columns����
					var columns = $('#dispwardgrid').datagrid("options").columns;
					var columnsstr=$('#dispwardgrid').datagrid('getColumnFields',false);
					var columni=columnsstr.indexOf(field);
					// �õ�rows����
					var rows = $('#dispwardgrid').datagrid("getRows"); // ��ĳ����Ԫ��ֵ
					rows[rowIndex][columns[0][columni].field]=tmpcheck;
					$('#dispwardgrid').datagrid('refreshRow', rowIndex);
				}
				wardIdStr=""
				dispCatArr=""
				var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
				dispCatPid=tkMakeServerCall("web.DHCSTPCHCOLLS","NewPid");
				var selecteddata=$('#dispwardgrid').datagrid('getData').rows[rowIndex];
				SaveCatList(selecteddata)
				wardIdStr=selecteddata["TWardRowid"]
				var params=GetQueryDispParams(selecteddata)
				var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
				var tabtwotitle=tabtwoselect.panel('options').title;
				if (tabtwotitle=="������"){
					if (dispCatArr==""){
						$.messager.alert('��ʾ',"������ѡ��һ����ҩ���!");
						params=""
					}
				}
				QueryDisp(params);
			}
			else{
				var tmpcheck=""
				if (value=="Y"){tmpcheck="N"}
				else{tmpcheck="Y"}
				$('#dispwardgrid').datagrid('updateRow',{
					index: rowIndex,
					row: {TSelect:tmpcheck}
				})
			}
		}
	});
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}
function renderAsCheckBox(value,row,index){
	if (value=="Y"){	
		return '<input type="checkbox" name="DataGridCheckbox" checked="checked">';
	}
	else{
		return '<input type="checkbox" name="DataGridCheckbox">';
	}
}
function InitDispList(){
	//����columns
	var columns=[[
		{field:'TSelect',title:'<a id="TDispSelect" href="#" onclick="SetSelectAll()">ȫ��</a>',width:30,
			formatter:function(value,row,index){
				if ((value=="")||(value=="Y")||(value==undefined)){
					return '<input type="checkbox" name="DispDataGridCheckbox" checked="checked" >';
				}
				else{
					return '<input type="checkbox" name="DispDataGridCheckbox" >';
				}
			}
		},
		{field:"TPID",title:'TPID',width:80,hidden:true},		
		{field:"TAdmLoc",title:'����',width:125,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},	
		{field:"TBedNo",title:'����',width:80},	
		{field:"TUrgent",title:'�Ӽ�',width:35,align:'center',
			formatter:function(value,row,index){
				if (value=="Y"){
					return '<font color="red" size="3"><b>' + value + '</b></font>';
				}
			}
		},
		{field:"TPaName",title:'����',width:80},
		{field:"TRegNo",title:'�ǼǺ�',width:80,
			formatter:function(value,row,index){
				return "<a href='#' onclick='showSkinTestWindow("+index+")'>"+value+"</a>";
			}},
		{field:"TDesc",title:'ҩƷ����',width:200},		
		{field:"TQty",title:'����',width:50},		
		{field:"TUom",title:'��λ',width:50},		
		{field:"TSalePrice",title:'�ۼ�',width:70,align:'right'},		
		{field:"TOrdStatus",title:'ҽ��״̬',width:60},		
		{field:"TPhaCat",title:'���',width:80},		
		{field:"TDoseQty",title:'����',width:60},		
		{field:"TFreq",title:'Ƶ��',width:60},		
		{field:"TInstruction",title:'�÷�',width:80},	
		{field:"TDuration",title:'�Ƴ�',width:80},		
		{field:"TPrescNo",title:'������',width:90},		
		{field:"TAudited",title:'ҽ�����',width:80},		
		{field:"TGeneric",title:'ͨ����',width:150},		
		{field:"TForm",title:'����',width:100},	
		{field:"TBarcode",title:'���',width:80},		
		{field:"TManufacture",title:'����',width:150,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},
		{field:"TIncStk",title:'��λ',width:100},	
		{field:"TAmt",title:'���',width:80,align:'right'},	
		{field:"TUserAdd",title:'����ҽ��',width:60},			
		{field:"TTimeAdd",title:'�ƻ���ҩʱ��',width:130},		
		{field:"TDiagnose",title:'���',width:200},	
		{field:"TAge",title:'����',width:60},			
		{field:"Tsex",title:'�Ա�',width:60},	
		{field:"Taction",title:'��ע',width:80},			
		{field:"TEncryptLevel",title:'�����ܼ�',width:80},	
		{field:"TPatLevel",title:'���˼���',width:80},	
		{field:"TTimeDosing",title:'�ַ�ʱ��',width:80},	
		{field:"Tcooktype",title:'��ҩ��ʽ',width:80},
		{field:"Tseqno",title:'ҽ������',width:80},
		{field:"Tbill",title:'�Ƿ�Ƿ��',width:80},
		{field:"TInsuType",title:'ҽ�����',width:75},
		{field:"TinciQty",title:'��治��',width:60,hidden:true},		
		{field:"Tstr",title:'Tstr',width:80,hidden:true},
		{field:"TMainOrd",title:'TMainOrd',width:80,hidden:true},
		{field:"TDispIdStr",title:'TDispIdStr',width:80,hidden:true},
		{field:"TColType",title:'TColType',width:80,hidden:true},
		{field:"Toedis",title:'Toedis',width:80,hidden:true},
		{field:"TBatchNo",title:'����',width:80,hidden:true},
		{field:"TarcEndDate",title:'ҽ����ֹ����',width:80,hidden:true},
		{field:"TarcEndDateFlag",title:'TarcEndDateFlag',width:80,hidden:true}								
	]];
	//����datagrid
	$('#dispgrid').datagrid({
		border:false,
		url:commonInPhaUrl+'?action=jsQueryDispList',
		fit:true,
		//rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//chectOnCheck: true, 
		//checkOnSelect: true,
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
		pagination:true,
		onLoadSuccess: function(){
 			$("#TDispSelect").text("ȫ��")
	    },
	    onBeforeLoad:function(param){
			KillTmpBeforeLoad();
		},
		rowStyler: function(index,row){
		        if (row.TarcEndDateFlag=="1"){
                    return 'color:#ff0066;font-weight:bold';
                }
				if (row.TinciQty!="1"){
                    return 'color:#00cc00;font-weight:bold';
                }

		},
	    onSelect:function(rowIndex,rowData){
	    },
	  	onClickCell: function (rowIndex, field, value) {
			if (field=="TSelect"){
				var tmpcheckvalue=""
				if (value=="Y"){tmpcheckvalue="N"}
				else{tmpcheckvalue="Y"}
				$('#dispgrid').datagrid('updateRow',{
					index: rowIndex,
					row: {TSelect:tmpcheckvalue}
				})				
				var selecteddata=$('#dispgrid').datagrid('getData').rows[rowIndex];
				Savetofitler(selecteddata)
				//����ҽ��ѡ��
				SelectLinkOrder(rowIndex)
			}
		}

	});

	initScroll("#dispgrid"); //�˳�ʼ���ᵼ��Ĭ��������1
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}

function SetSelectAll()
{
	var dispgridrowsdata=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridrowsdata.length;
	if (dispgridrows<=0){
		return;
	}
	var tmpSelectFlag=""
	if($("#TDispSelect").text()=="ȫѡ"){
		$("#TDispSelect").text("ȫ��")
		tmpSelectFlag="Y"
		//$("input[type=checkbox][name=DispDataGridCheckbox]").attr('checked',true)
	}else{
		$("#TDispSelect").text("ȫѡ")
		tmpSelectFlag="N"
		//$("input[type=checkbox][name=DispDataGridCheckbox]").attr('checked',false)
	}
	var columns = $('#dispgrid').datagrid("options").columns;
	var columnsstr=$('#dispgrid').datagrid('getColumnFields',false);
	var columni=columnsstr.indexOf("TSelect");
	$.each(dispgridrowsdata, function(index, item){
		dispgridrowsdata[index][columns[0][columni].field]=tmpSelectFlag;
		$('#dispgrid').datagrid('refreshRow', index);
		var selecteddata=$('#dispgrid').datagrid('getData').rows[index];
		Savetofitler(selecteddata)
	})
}
function InitDispTotalList(){
	//����columns
	var columns=[[
		{field:"TDesc",title:'ҩƷ����',width:200},
		{field:"TQty",title:'����',width:60},
		{field:"TUom",title:'��λ',width:60},
		{field:"TSp",title:'�ۼ�',width:80,align:'right'},
		{field:"TAmt",title:'���',width:80,align:'right'},
		{field:"TDrugForm",title:'����',width:100},
		{field:"TQtyBed",title:'����/����',width:80},
		{field:"TBarcode",title:'���',width:100},
		{field:"TManufacture",title:'����',width:150,
			formatter:function(value,row,index){
				if (value.indexOf("-")){
					return value.split("-")[1];
				}else{
					return value;
				}
			}
		},
		{field:"TIncstk",title:'��λ',width:100},
		{field:"TGeneric",title:'ͨ����',width:150}
		
	]];
	//����datagrid
	$('#disptotalgrid').datagrid({
		border:false,
		url:commonInPhaUrl+'?action=jsQueryDispTotalList',
		fit:true,
		rownumbers:true,
		nowrap:false,
		columns:columns,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		selectOnCheck: true, 
		checkOnSelect: true,
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100,300,500],   // ��������ÿҳ��¼�������б�
		pagination:true,
		onLoadSuccess: function(){
 	
	    },
	    onSelect:function(rowIndex,rowData){
		   
	    }

	});
	//$('#dispwardgrid').gridupdown($('#dispwardgrid'));
}
function InitDispAdmList()
{
	
	//����columns
	var columnspat=[[
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'CurrWard',title:'����',width:150},
		{field:'AdmDate',title:'��������',width:80},
		{field:'AdmTime',title:'����ʱ��',width:80},
		{field:'AdmLoc',title:'�������',width:150},
		{field:'CurrentBed',title:'����',width:100}
	]];
	
	//����datagrid
	$('#dispadmgrid').datagrid({
		url:commonInPhaUrl+'?action=QueryDispAdmList',
		toolbar:'#patconditiondiv',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columnspat,
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
				var selecteddata=$('#dispadmgrid').datagrid('getData').rows[rowIndex];
				var params=GetQueryDispParams(selecteddata)
				QueryDisp(params);
		}
	});
}

function getPhaLocDispType(phaLocId)
{
	phaLocDispCat=""
	var columns=new Array();
	var column={};
	column.title="TWardRowid";
	column.field="TWardRowid";
	column.hidden=true;
	columns.push(column);
	column={};
	column.title="����";
	column.field="TWard";
	column.width=150;
	columns.push(column);
	column={};
	column.title="ѡ��";
	column.field="TSelect";
	//column.checkbox=true;
	//ormatter:function(value,row,index){
	column.formatter=renderAsCheckBox
	column.width=35;
	
	columns.push(column);
	column={};
	var dispcatsstr=tkMakeServerCall("web.DHCSTPHALOC","GetPhaLocDispType",phaLocId);
	var dispcatsarr=dispcatsstr.split("^");
	var dispcatslength=dispcatsarr.length;
	var dispcatsi=0
	for (dispcatsi=0;dispcatsi<dispcatslength;dispcatsi++){
		column={};
		var dispcatsdescarr=dispcatsarr[dispcatsi].split("@");
		var dispcatsdesc=dispcatsdescarr[1];
		if (dispcatsdesc=="") {continue;}
		var newdispcatdesc=dispcatsdesc.substring(0,2)+"</br>"+dispcatsdesc.substring(2,4)
		if(dispcatsdesc.length>4){
			var newdispcatdesc=newdispcatdesc+"</br>"+dispcatsdesc.substring(4,6)
		}
		var dispcatscode=dispcatsdescarr[0];
		if (phaLocDispCat==""){phaLocDispCat=dispcatscode}
		else{phaLocDispCat=phaLocDispCat+"^"+dispcatscode}
		column.title=newdispcatdesc;
		column.field=dispcatscode;
		column.formatter=renderAsCheckBox
		columns.push(column);
	}
	return columns
}
function InitCondition(){
	//$("#startDate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	//$("#endDate").datebox("setValue", formatDate(0));  //Init�������� 
}
function InitTitle(){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonOutPhaUrl+'?action=GetPminoLen',//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if (value!=""){
				hisPatNoLen=value;
			}   
		},    
		error:function(){        
			alert("��ȡ�ǼǺų���ʧ��!");
		}
	});
	GetPhaLocConfig(gLocId);

}
function GetPhaLocConfig(locRowId){
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonInPhaUrl+'?action=GetInPhaConfig&gLocId='+locRowId,//�ύ������ �����ķ���  
		data: "",
		success:function(value){   
			if (value!=""){
				SetPhaLocConfig(value)
			}   
		},    
		error:function(){        
			alert("��ȡסԺҩ����������ʧ��!");
		}
	});
}
function QueryDispWardList(){
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if ($('#phaLoc').combobox("getText")==""){phaLoc=""}
	if (phaLoc==""){
		$.messager.alert('������ʾ',"ҩ��������Ϊ��!");
		return;
	}
	var wardLoc=$('#wardLoc').combobox("getValue");
	if ($('#wardLoc').combobox("getText")==""){wardLoc=""}
	var locGroupId=$('#locGroup').combobox("getValue");
	if ($.trim($('#locGroup').combobox("getText"))==""){
		locGroupId=""
	}
	var priority=$("#priority").val();
	var params=startDate+"!!"+startTime+"!!"+endDate+"!!"+endTime+"!!"+phaLoc+"!!"+wardLoc+"!!"+locGroupId+"!!"+priority;
	$('#dispwardgrid').datagrid({
		url:commonInPhaUrl+'?action=QueryDispWardList',	
		queryParams:{
			params:params}
	});
}
 //��ѯѡ�����ķ�ҩ��ϸ
function QuerySelectDispList(){
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	if (tabtwotitle=="������"){
		var dispwardgridrowsdata=$('#dispwardgrid').datagrid("getRows");
		var dispwardgridrows=dispwardgridrowsdata.length;
		if (dispwardgridrows<=0){
			return;
		}
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
		dispCatPid=tkMakeServerCall("web.DHCSTPCHCOLLS","NewPid");
		wardIdStr=""
		$.each(dispwardgridrowsdata, function(index, item){
			if(item["TSelect"]=="Y"){
				if (wardIdStr==""){wardIdStr=item["TWardRowid"];}
				else{wardIdStr=wardIdStr+"^"+item["TWardRowid"];}
				SaveCatList(item)				
			}
		})
		var params=GetQueryDispParams(dispwardgridrowsdata[0])  //����ȥֵ�жϲ��ǰ��ǼǺ�
		QueryDisp(params);
	}
	else{
		$.messager.alert('��ʾ',"����������ҩʱ����ѡ��!");
		return;	
	}

}
//��ѯ��ҩ������Ϣ
function QueryDispAdmList(){
	var patNo=$("#patNo").val();
	var params=patNo
	$('#dispadmgrid').datagrid({
		queryParams:{
			params:params}
	});
}
//��ѯ��ҩ��Ϣ
function QueryDisp(params){
	$('#dispgrid').datagrid('loadData',{total:0,rows:[]}); 
    $('#dispgrid').datagrid('options').queryParams.params = params;//����ֵ  
    $("#dispgrid").datagrid('reload');//���¼���table  
}
function GetQueryDispParams(selecteddata){
	var wardLoc=wardIdStr;
	var startDate=$('#startDate').datebox('getValue');
	if (startDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var endDate=$('#endDate').datebox('getValue');
	if (endDate==""){
		$.messager.alert('������ʾ',"�����뿪ʼ����!");
		return;
	}
	var startTime=$('#startTime').timespinner('getValue');
	var endTime=$('#endTime').timespinner('getValue');
	var phaLoc=$('#phaLoc').combobox("getValue")
	if ($('#phaLoc').combobox("getText")==""){phaLoc=""}
	if (phaLoc==""){
		$.messager.alert('������ʾ',"ҩ��������Ϊ��!");
		return;
	}
	var inciRowId=$("#textInciRowId").val()
	if ($.trim($("#textInci").val())==""){inciRowId=""}
	var ByWardFlag=""
	var pri=$("#priority").val();
	var dispCats=dispCatArr+"#"+pri+"#"+dispCatPid;
	var adm=selecteddata["Adm"]
	if(adm==undefined){adm=""} //������
	else{
		wardLoc=""
		if (phaLocDispCat==""){
			$.messager.alert('������ʾ',"ҩ����ҩ���Ϊ��,���ؽ�!");
			return;
		}
		dispCats=phaLocDispCat+"#"+pri
	}
	var DoctorLocRowid=""
	var NotAudit=""
	var OutOrdFlag=0,longOrdFlag=0,shortOrdFlag=0,isPackFlag="",emOrdFlag="NOEmOrd"
	if ($('#checkedOut').is(':checked')){OutOrdFlag=1}
	if ($('#checkedLong').is(':checked')){longOrdFlag=1}
	if ($('#checkedShort').is(':checked')){shortOrdFlag=1}
	if ($('#checkedIsPack').is(':checked')){isPackFlag="ISPACK"}
	if ($('#checkedNotPack').is(':checked')){isPackFlag="NOPACK"}
	if ($('#checkedEMY').is(':checked')){emOrdFlag="EmOrd"}
	var shortOrdFlagStr=shortOrdFlag+"||"+emOrdFlag+"||"+isPackFlag
	var params=phaLoc+"!!"+wardLoc+"!!"+startDate+"!!"+endDate+"!!"+gUserId+"!!"+
			   ByWardFlag+"!!"+longOrdFlag+"!!"+shortOrdFlagStr+"!!"+OutOrdFlag+"!!"+dispCats+"!!"+
			   adm+"!!"+DoctorLocRowid+"!!"+NotAudit+"!!"+startTime+"!!"+endTime+"!!"+inciRowId
	return 	params;

}
function SaveCatList(selecteddata){				
	var wardLoc=selecteddata["TWardRowid"];
	var columnsstr=$('#dispwardgrid').datagrid('getColumnFields',false);
	var dispcatsstr=""
	var columnslength=columnsstr.length;
	for (var columni=0;columni<columnslength;columni++){
		var columnname=columnsstr[columni]
		if ((columnname=="TWardRowid")||(columnname=="TWard")||(columnname=="TSelect")){
			continue;
		}
		if (selecteddata[columnname]=="Y"){
			if (dispcatsstr==""){dispcatsstr=columnname}
			else{dispcatsstr=dispcatsstr+"^"+columnname}
		}
	}
	dispCatArr=dispcatsstr
	var savecatret=tkMakeServerCall("web.DHCSTPCHCOLLS","SaveCatListByWard",wardLoc,dispcatsstr,dispCatPid);
	
}
function SetPatInfo(RegNo)
{    
	if (RegNo=="") {
		return;
	}
	var patLen = hisPatNoLen;
	var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('��ʾ',"�ǼǺ��������","warning");
		return;
	}
	for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$("#patNo").val(RegNo);
	$.ajax({  
		type: 'POST',//�ύ��ʽ post ����get  
		url: commonInPhaUrl+'?action=GetPatInfoByNo&patNo='+RegNo,//�ύ������ �����ķ���  
		data: "",
		success:function(value){     
			if ($.trim(value)!=""){
				var painfoarr=value.split("^")	;
				if (painfoarr.length >0){
					var patInfoText="����:"+painfoarr[0]+"���Ա�:" +painfoarr[1] + "����������:" +painfoarr[2]+"("+painfoarr[3]+")";
					$("#patInfo").text(patInfoText)
				}
				QueryDispAdmList();
			}else{
				$.messager.alert('��ʾ',"�����ڸò��ˣ�","info");
				return;
			}   
		},    
		error:function(){        
			alert("��ȡ���˻�������ʧ��!");
		}
	});
}
function Savetofitler(selectrowdata)
{
	//��ʱ���淢ҩʱû��ѡ���ҽ��Rowid
	var tdispstr=selectrowdata["TDispIdStr"];
	var tpid=selectrowdata["TPID"];
	var selected=selectrowdata["TSelect"];
	if (selected=="Y"){selected="D";}
	else{selected="S";}
	if ((tpid!="")&&(tpid!=undefined)){
		var saveret=tkMakeServerCall("web.DHCSTPCHCOLLS","SaveToFilter",tpid,tdispstr,selected)
	}
}
 //����ҽ��ѡ��
function SelectLinkOrder(selectrow){
	var selecteddata=$('#dispgrid').datagrid('getData').rows[selectrow];
	var tmpselect=selecteddata["TSelect"]
	var toedis=selecteddata["Toedis"];
	var orderlinkret=CheckOrderLink(toedis).split("%");
	var oeoricnt=orderlinkret[0] 
	if (oeoricnt>0){
		var mainoeori=selecteddata["TMainOrd"]; //��ҽ��id
		var dodisdate=selecteddata["TTimeAdd"]
		var mainindex=mainoeori+"^"+dodisdate
		var dispgridselect=$('#dispgrid').datagrid("getRows");
		var dispgridrows=dispgridselect.length;
		for(var i=0;i<dispgridrows;i++){
			var tmpselecteddata=dispgridselect[i];
			var tmpmainoeori=tmpselecteddata["TMainOrd"]
			var tmpdodisdate=tmpselecteddata["TTimeAdd"]
			var tmpmainindex=tmpmainoeori+"^"+tmpdodisdate;
			if (mainindex==tmpmainindex){
				$('#dispgrid').datagrid('updateRow',{
					index: i,
					row: {TSelect:tmpselect}
				})
				var newselectdata=$('#dispgrid').datagrid('getData').rows[i];
				Savetofitler(tmpselecteddata)
			}
		}
	}
}
 //�ж��Ƿ�Ϊ����ҽ��
function CheckOrderLink(oedisstr){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLS","CheckLinkOeord",oedisstr)
	return ret;
}
//�ܾ���ҩ
function btnRefuseHandler(){
	var taboneselect=$('#tabsone').tabs('getSelected'); 
	var tabonetitle=taboneselect.panel('options').title;
	if (tabonetitle!="��ҩ��ϸ"){
		$.messager.alert('��ʾ',"����ѡ�ѡ��ҩ��ϸ��ѡ��ܾ���ҩ!!");
		return;
	}
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	if(selecteddata["TPID"]==""){
		$.messager.alert('��ʾ',"û����ϸ!");
		return;
	}
	if (!confirm("�Ƿ�ȷ�Ͼܾ���ҩ?")){return;}
	var ordArr = new Array(); 	
	var dispgridselect=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridselect.length;
	for(var i=0;i<dispgridrows;i++){
		var tmpselecteddata=dispgridselect[i];
		var tmpselect=tmpselecteddata["TSelect"];
		if (tmpselect!="Y"){continue;}
		var tmpdispidstr=tmpselecteddata["TDispIdStr"];
		if(!ordArr.contains(tmpdispidstr)){
			ordArr.push(tmpdispidstr)
		}
	}
	if (ordArr.length==0){
		$.messager.alert('��ʾ',"��ѡ����Ҫ�ܾ���ҩ����ϸ!");
		return;
	}
	var resondr=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.setdrugrefusereason','','dialogHeight:550px;dialogWidth:550px;center:yes;help:no;resizable:no;status:no;scroll:no')
	if (!resondr) return;
	if (resondr!="")
	{
	   var restmp=resondr.split("^")
	   resondr=restmp[0]
	   resondesc=restmp[1]
	}
	tkMakeServerCall("web.DHCSTPCHCOLLS","InsertDrugRefuse",ordArr.join("^"),gUserId,resondr)
	$("#dispgrid").datagrid("reload");
	
}
//��ҩ
function btnDispHandler(){
	var dispuser=""
	var operateuser=""
	var phaLoc=$('#phaLoc').combobox("getValue")
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	var taboneselect=$('#tabsone').tabs('getSelected'); 
	var tabonetitle=taboneselect.panel('options').title;
	if (tabonetitle!="��ҩ��ϸ"){
		$.messager.alert('��ʾ',"����ѡ�ѡ��ҩ��ϸ��ѡ��ҩ!!");
		return;
	}
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	var pid=selecteddata["TPID"]
	if(pid==""){
		$.messager.alert('��ʾ',"û����ϸ!");
		return;
	}
	if (phaLocDispCat==""){
		$.messager.alert('��ʾ',"ҩ����ҩ���Ϊ��,���ؽ�!");
		return;
	}
	if (!confirm("�Ƿ�ȷ�Ϸ�ҩ?")){return;}
	if (tabtwotitle!="������"){
		var selectedadmdata = $('#dispadmgrid').datagrid('getSelected');
		var adm=selectedadmdata["Adm"]
		var billret=tkMakeServerCall("web.DHCSTPCHCOLLS","RetBillControl",pid,adm)
		if (billret=="N"){
			$.messager.alert('��ʾ',"�ò�����Ƿ��!");
			return;
		}
	}
	//ȡ�Ƿ�¼�뷢ҩ������
	if (paramStr!="")
	{
		var tmparr=paramStr.split("^");
		var dispuserflag=tmparr[17];
		var operaterflag=tmparr[21];
		if (dispuserflag=="Y"){
			var dispuser=window.showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phauserdialog&grp='+gGroupId,"_target",'dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no;')
			if (dispuser==""){
				$.messager.alert('��ʾ',"��ѡ��ҩ�˺�����!");
				return;
			}
	    }
	   	if (operaterflag=="Y"){
		   	var operateuser=window.showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phaoperaterdialog&grp='+gGroupId,"_target",'dialogHeight:450px;dialogWidth:350px;center:yes;help:no;resizable:no;status:no;scroll:no;')
			if (operateuser==""){
				$.messager.alert('��ʾ',"��ѡ���ҩ�˺�����!");
				return;
			} 
	    }
	}
	//��Ժ��ҩ��ҩ
	if ($('#checkedOut').is(':checked')){
		DispOutOrder(pid,dispuser,operateuser,phaLoc);
		return;
	}
	//������ҩ
	catarr=phaLocDispCat.split("^")
   	var phacrowidStr=""
   	var wardArr=wardIdStr.split("^");
 	for (var wardi=0;wardi<wardArr.length;wardi++){
	   	var wardid=wardArr[wardi]
	   	if (tabtwotitle=="������"){
			var catstr=tkMakeServerCall("web.DHCSTPCHCOLLS","GetWardDispType",dispCatPid,wardid); //js��ֱ�ӵ�����ķ���
   		    catarr=catstr.split("^");
		}
		for (var cati=0;cati<catarr.length;cati++){
			var cat=catarr[cati];
			if(cat==""){return;}
			var PhacRowid=SaveDispensing(cat,pid,phaLoc,wardid,dispuser,operateuser) ;
			if (PhacRowid>0){
				if(phacrowidStr!=""){
					phacrowidStr=phacrowidStr+"A"+PhacRowid;		
				}else{
					phacrowidStr=PhacRowid;					
				}
			}else if (PhacRowid<0){
				alert("��ҩ���:"+GetDispCatNameByCode(cat) + ","+PhacRowid) ;
			}
		}
 	}
 	GetTipsOfNoStock(pid);
 	if ((phacrowidStr=="")||(phacrowidStr==0)){
 		alert("δ����ҩƷ!") ;
 		return;
 	}
 	//�����ҩ
	if ($('#checkedReserve').is(':checked')){
		var reserveret=tkMakeServerCall("web.DHCSTPCHCOLLS","ExeRetAfterDisp",pid,phacrowidStr,gUserId)
	}
	if (confirm("�Ƿ��ӡ"))
	{
		PrintReport(phacrowidStr,pid);
	}
	//��ҩ��
	SendOrderToMachine(phacrowidStr);
	killTmpAfterSave(pid);
	$("#TDispSelect").text("ȫ��")
	$("#dispgrid").datagrid("reload");
}
 //��Ժ��ҩ��ҩ
function DispOutOrder(pid,dispuser,operateuser,phaLoc){
	if (pid==""){return;}
	var ss=[];
    var outdrugPhacs=""
    var outdrugPhastr=""
	var wardArr=wardIdStr.split("^");
	var catarr=phaLocDispCat.split("^")
	for (var wardi=0;wardi<wardArr.length;wardi++){
	   	var wardid=wardArr[wardi]
		for (var cati=0;cati<catarr.length;cati++){
			var cat=catarr[cati];
			var PhacRowid=SaveDispensing(cat,pid,phaLoc,wardid,dispuser,operateuser) ;
			if (PhacRowid>0 ){  
				if (outdrugPhacs=="") {outdrugPhacs=PhacRowid}
				else {outdrugPhacs=outdrugPhacs+"^"+PhacRowid }
			}
			if (PhacRowid<0){	
			    alert("��ҩ���:"+GetDispCatNameByCode(cat) + ",��ҩʧ��,�������:"+PhacRowid) ;
			} 
		}
   	}
   	GetTipsOfNoStock(pid);
	killTmpAfterSave(pid);
	if (outdrugPhacs==""){
		$("#dispgrid").datagrid("reload");
		return;
	}
	var pcods=tkMakeServerCall("web.DHCSTPCHCOLLOUT","CreateOutDrugRecords",phaLoc,gUserId,outdrugPhacs)
	if (pcods==""){return ;}
	var outdrugPhastr=""
	var outdrugPhacsArr=outdrugPhacs.split("^")
	if (outdrugPhacsArr.length>=0){
		for (var outi=0;outi<outdrugPhacsArr.length;outi++){
			if (outdrugPhastr==""){OutString=outdrugPhacsArr[outi]}
			else{outdrugPhastr=outdrugPhastr+"A"+outdrugPhacsArr[outi]}
		}
		PrintReport(outdrugPhastr,pid)  ; 
	}
	$("#dispgrid").datagrid("reload");
}
function SaveDispensing(dispcat,pid,phaLoc,wardid,dispuser,operateuser){
	var PhacRowid=tkMakeServerCall("web.DHCSTPCHCOLLS","SAVEDATA","","",dispcat,pid,dispuser,operateuser,'',phaLoc,wardid) ;
	return PhacRowid ;  
}
function SendOrderToMachine(phacStr){
	if (paramStr!=""){
		var tmparr=paramStr.split("^");
		var sendflag=tmparr[31];
		if (sendflag=="Y"){
			var senderr=0
			phacArr=phacStr.split("A");	
			for(var phaci=0;phaci<phacArr.length;phaci++){
				var phac=phacArr[phaci].split("B");
			    var pharowid=phac[0]
				var sendret=tkMakeServerCall("web.DHCSTInterfacePH","SendOrderToMechine",pharowid)
			    if (sendret!=0){
				    var retString=sendret
				    var senderr=1
			    }
			}
			if (senderr=="1"){
				$.messager.alert("������ʾ","���Ͱ�ҩ��ʧ��!��ע���ʵ!"+retString)
				return;
			}
		}
	}
}
function GetDispCatNameByCode(catcode){
	var dispcatname=tkMakeServerCall("web.DHCINPHA.InfoCommon","GetDispCatDescByCode",catcode)
	return dispcatname;
}
function GetTipsOfNoStock(pid){
	var ret=tkMakeServerCall("web.DHCSTPCHCOLLS","GetTipsOfNoStock",pid);
	if (ret!=""){alert(ret+"  ��治��,���¶�Ӧ����ҽ���޷���ҩ��")}
}
function killTmpAfterSave(pid)
{
	tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmpAfterSave","","",pid)
}
function PrintReport(phacstr,pid){
	PrintRep(phacstr,"",pid,"")
}
//����ҩ������
function SetPhaLocConfig(configstr){
	paramStr=configstr
	var configarr=configstr.split("^");
	var startdate=configarr[2];
	var enddate=configarr[3] ;
	var notwardrequired=configarr[0];
	var auditneed=configarr[10];
	var retflag=configarr[11]; 
	var dispuserflag=configarr[17];
	var operaterflag=configarr[21];
	var aduitBillflag=configarr[22];
	var disptypelocalflag=configarr[23];
	var displayemyflag=configarr[24];
	var displayoutflag=configarr[25];
	var lsflag=configarr[26];
	var reqwardflag=configarr[27];
	var dispdefaultflag=configarr[28];
	InitDateBox("startDate",startdate)
	InitDateBox("endDate",enddate)
	if(retflag=="Y"){
		$('#checkedReserve').attr('checked',true); 
	}else{
		$('#checkedReserve').attr('checked',false); 
	}
	if(dispdefaultflag=="0"){
		$('#checkedShort').attr('checked',true); 
	}else if(dispdefaultflag=="1"){
		$('#checkedLong').attr('checked',true);
	}else{
		$('#checkedShort').attr('checked',false); 
		$('#checkedLong').attr('checked',false);
	}
}
 //�ǼǺ�����,yunhaibao,20160615,ֱ�Ӵ�value��֪������������ʲô
function showSkinTestWindow(indexrow){
	var dispselectdata=$('#dispgrid').datagrid('getData').rows[indexrow];
	var regNo=dispselectdata["TRegNo"];
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.getskintest&RegNo="+regNo;
	window.open(lnk,"Ƥ�Լ�¼","height=300,width=400,menubar=no,status=yes,toolbar=no,resizable=yes") ;
}
function InitDateBox(dateid,datenum){
	var newdatenum=0;
	datenum=datenum.toUpperCase();
	if (datenum.indexOf("T")>=0){
		if (datenum=="T"){newdatenum=0}
		else{
			newdatenum=datenum.substring(1,datenum.length)
		}
	}
	$("#"+dateid).datebox("setValue", formatDate(newdatenum));
} 
function getDrugList(returndata){
	if (returndata["Inci"]>0){
		$("#textInci").val(returndata["InciDesc"]);
		$("#textInciRowId").val(returndata["Inci"]);
	}
	else{
		$("#textInci").val("");
		$("#textInciRowId").val("");
	}
}
 //����ѡ
function SetConditionCheck(checkboxid){
	var boolchecked=""
	if ($('#'+checkboxid).is(':checked')){
		boolchecked="1"
	}
	if (boolchecked=="1"){
		if(checkboxid=="checkedOut"){
			$('#checkedLong').attr('checked',false); 
			$('#checkedShort').attr('checked',false); 
		}else if (checkboxid=="checkedLong"){
			$('#checkedOut').attr('checked',false); 
			$('#checkedShort').attr('checked',false);
		}else if (checkboxid=="checkedShort"){
			$('#checkedLong').attr('checked',false); 
			$('#checkedOut').attr('checked',false);
		}else if (checkboxid=="checkedIsPack"){
			$('#checkedNotPack').attr('checked',false); 
		}else if (checkboxid=="checkedNotPack"){
			$('#checkedIsPack').attr('checked',false); 
		}
	}
	CollectHandler();
}
function CollectHandler(){
	var tabtwoselect=$('#tabstwo').tabs('getSelected'); 
	var tabtwotitle=tabtwoselect.panel('options').title;
	var tmpselectdata=null;
	if (tabtwotitle=="������"){
		tmpselectdata=$('#dispwardgrid').datagrid("getSelected");
	}
	else if (tabtwotitle=="�ǼǺ�"){
		tmpselectdata=$('#dispadmgrid').datagrid("getSelected");
	}
	if (tmpselectdata==null){
		return;
	}
	var params=GetQueryDispParams(tmpselectdata)
	QueryDisp(params);
}
//ˢ�·�ҩ����tab
function RefTabOne(){
	var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
	var params;
	if (selecteddata==null){
		params="";	
	}else{
		params=selecteddata["TPID"]; 
	}
	//$('#disptotalgrid').datagrid('options').queryParams.params = params;//����ֵ  
    //$("#disptotalgrid").datagrid('reload');//���¼���table  
	$('#disptotalgrid').datagrid({
		url:commonInPhaUrl+'?action=jsQueryDispTotalList',	
		queryParams:{
			params:params}
	});
}
//ˢ�²����ǼǺ�tab
function RefTabTwo(){
	$('#dispadmgrid').datagrid({
		queryParams:{
			params:''}
	});
}
//��շ�ҩ��ϸ
function ClearDispGrid(){
	var params=""
	$('#dispgrid').datagrid({
	url:commonInPhaUrl+'?action=jsQueryDispList',	
	queryParams:{
		params:params}
	});
}
function KillTmpBeforeLoad(){
	var dispgridrowsdata=$('#dispgrid').datagrid("getRows");
	var dispgridrows=dispgridrowsdata.length;
	if (dispgridrows>0){
		var selecteddata=$('#dispgrid').datagrid('getData').rows[0];
		var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillBeforeLoad",selecteddata["TPID"])
	}
}
//mac��ַ
///
function InitComputerMac(){
   var macAddr="";
   var locator = new ActiveXObject ("WbemScripting.SWbemLocator");  
   var service = locator.ConnectServer("."); //���ӱ���������
   var properties = service.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration Where IPEnabled =True");  //��ѯʹ��SQL��׼ 
   var e = new Enumerator (properties);
   var p = e.item ();
   for (;!e.atEnd();e.moveNext ())  
   {
	  	var p = e.item ();  
	  	if(p.MACAddress==null){
			continue;
		}
		macAddr=p.MACAddress;
		if(macAddr) break;
	}
	$("#macAddr").val(macAddr)
}
//�ͻ�������ȡ���ȼ�
function SetLocalConfig(checkboxid){
	var checkedflag=""
	if ($('#'+checkboxid).is(':checked')){
		checkedflag="1"
	}
	if(checkedflag!="1"){
		$("#priority").val("");
		return;
	}else{
		var phaLoc=$('#phaLoc').combobox("getValue")
		var mac="**"+$("#macAddr").val();
		var retval=tkMakeServerCall("web.DHCSTPHACONFIG", "GetPhaLocConfigByLoc",phaLoc,mac,gUserId);
		$("#priority").val(retval);
	}
}
//�ж��������Ƿ����Ԫ��
Array.prototype.contains = function (obj) {  
    var i = this.length;  
    while (i--) {  
        if (this[i] === obj) {  
            return true;  
        }  
    }  
    return false;  
} 

window.onbeforeunload = function (){
	if (CurKFlag=="0"){
		CurKFlag="";
		return;
	}
	KillTmpBeforeLoad();
	var killret=tkMakeServerCall("web.DHCSTPCHCOLLS","KillTmp",dispCatPid);
}
