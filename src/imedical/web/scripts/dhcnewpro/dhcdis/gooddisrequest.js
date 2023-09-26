
var Split="" ;		// ��ֱ�־
var UNsplit="" ;	// ��ֱ�־	
var itmid="" ;
var createUser=""; 	// ������ dws 2017-02-24

$(function(){ 

	initCombobox();  /// ��ʼ��combobox
	CustomEditor();  /// �Զ���༭��
	initParam();	 /// ��ʼ������
	initDate();		 /// ��ʼ��ʱ��ؼ�
	initTable();	 /// ��ʼ��easyui datagrid
	initMethod();	 /// ��ʼ���ؼ��󶨵��¼�
	initDisTime();	 /// ��������Ĭ�ϵ�ǰ
	
});

//��ʼ��������
function initCombobox()
{
	$('#disType').combobox({    
    	url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisTypeCombobox",    
    	valueField:'id',    
    	textField:'text',
    	onChange: function () {
			 var rows = $("#datagrid").datagrid('getRows');
			 for ( var i = 0; i < rows.length; i++) {
		         $("#datagrid").datagrid('endEdit', i);
			} 
		},
		onSelect:function(option){
			LoadCheckItemList(option.id)
		}
	});
	$('#ApplayLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#RecLoc').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatus').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusComboS&type="+1,// type 0: ���� ,1: ����
		valueField:'id',    
	    textField:'text' 
	});
	
	$('#currLoca').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISGoodsRequest&MethodName=GetCurrLoca",
		valueField:'id',    
	    textField:'text',
	    mode:'remote',
	    panelHeight:"auto",  
	});
	
}
function CustomEditor()
{
	 $.extend($.fn.datagrid.defaults.editors, {
		combogrid: {
			init: function(container, options){
				var input = $('<input type="text" class="datagrid-editable-input">').appendTo(container); 
				//options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&Loc='+$('#recLoc').combobox('getValue');
				options.url='dhcapp.broker.csp?ClassName=web.DHCDISCommonDS&MethodName=DisLocItmComboGrid&type='+$('#disType').combobox('getValue');
				input.combogrid(options);
				return input;
			},
			destroy: function(target){
				$(target).combogrid('destroy');
			},
			getValue: function(target){
				return $(target).combogrid('getText');
			},
			setValue: function(target, value){
				$(target).combogrid('setValue', value);
				
			},
			resize: function(target, width){
				$(target).combogrid('resize',width);
			}
		}
	});
}

/*//������������
function save(flag)   ///������������ʱ�Ӳ���  sufan 2018-03-22
{
	if(!$('#detail').form('validate')){
		return;	
	}
	var rows = $("#datagrid").datagrid('getRows');
	for ( var i = 0; i < rows.length; i++) {
         $("#datagrid").datagrid('endEdit', i);
	}
	var LocIDStringLength=$("#recLoc").combobox('getValues').length;
	if((LocIDStringLength>1)&&(Split=="Y"))
	{
		$.messager.confirm('ȷ��', 'ȷ��Ҫ��ֳ�'+LocIDStringLength+'�����뵥��?', function(r){
		if (r){
				SplitSave(flag);
			}
		})
	}
	else{
		SplitSave(flag);
	}
	
	
}
//��ֱ���
function SplitSave(flag)
{
	var UrgentFlag=""  ///�Ӽ���־
		$("input[type=checkbox][name=urgentFlag]").each(function(){
			if($(this).is(':checked')){
				UrgentFlag='Y';
			}else{
				UrgentFlag='N'
			}
		})	
		var tableData=$("#datagrid").datagrid('getRows');
		var ItmlistData = [];
		for(var i=0;i<tableData.length;i++){
			//var data=tableData[i].itmid+"^"+tableData[i].locid+"^"+tableData[i].qty;
			var data=tableData[i].itmid+"^"+tableData[i].qty;
			ItmlistData.push(data);
		}
		var ItmInfo=ItmlistData.join("$$");

		var REQCreateUser=LgUserID   
		var REQLocDr=LgCtLocID;		
		var REQRecLocDr=$("#recLoc").combobox('getValues');
		var REQRemarks=$("#remark").val();  
		var REQExeDate=$('#exeDate').datetimebox('getValue').split(" ")[0] 
		var REQExeTime=$('#exeDate').datetimebox('getValue').split(" ")[1]      
		var REQCreateDate=(new Date()).Format("yyyy-MM-dd")            
		var REQCreateTime=(new Date()).Format("hh:mm:ss");
		var REQDisType=$("#disType").combobox('getValue');
		var RequestDateList=REQCreateUser+"^"+REQLocDr+"^"+REQRecLocDr+"^"+REQRemarks+"^"+REQExeDate+"^"+REQExeTime+"^"+REQCreateDate+"^"+REQCreateTime+"^"+REQDisType+"^"+UrgentFlag;
		runClassMethod("web.DHCDISGoodsRequest",
					"saveReqString",
					{'mainStrings':RequestDateList,'subStr':ItmInfo,"flag":flag},
					function(data){
						if(data==0)
						{
							$.messager.alert('��ʾ','����ɹ�');
							clearForm();
							search();
						}else{
							 $.messager.alert('��ʾ','����ʧ��'+data)
							 $("#datagrid").datagrid('reload')
							} 
					},"json")
}*/

/// ������������
function save(flag)
{
	if(!$('#detail').form('validate')){
		return;	
	}
	var rows = $("#datagrid").datagrid('getRows');
	for (var i = 0; i < rows.length; i++) {
         $("#datagrid").datagrid('endEdit', i);
	}
	var REQCreateUser = LgUserID  			// ������ 
	var REQLocDr = LgCtLocID;				// �������
	var REQRemarks = $("#remark").val();  	// ��ע
	var REQExeDate = $('#exeDate').datetimebox('getValue').split(" ")[0] 	// ��������
	var REQExeTime = $('#exeDate').datetimebox('getValue').split(" ")[1]    // ����ʱ��
	var REQCreateDate = (new Date()).Format("dd/MM/yyyy") 				    // ��������           
	var REQCreateTime = (new Date()).Format("hh:mm:ss");					// ����ʱ��   
	var REQDisType = $("#disType").combobox('getValue');					// ��������
	var UrgentFlag = $('#urgent').is(':checked')? "Y":"N";   				// �Ӽ�
	var Loction = LgCtLocID;												// ���뵥λ��
	var LoctionFlag = "1";													// ���뵥λ�ñ�ʶ
	var RequestDateList = REQCreateUser+"^"+REQLocDr+"^"+REQRemarks+"^"+REQExeDate+"^"+REQExeTime+"^"+REQCreateDate+"^"+REQCreateTime+"^"+REQDisType+"^"+UrgentFlag+"^"+Loction+"^"+LoctionFlag;
	var rowsData = $("#datagrid").datagrid('getChanges');
	if(rowsData.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var ReqdataList = [];
	for(var i=0;i<rowsData.length;i++){
		var ReqItm = rowsData[i].itm;     		// ������Ŀ
		var ReqItmId = rowsData[i].itmid;		// ������ĿID
		var ItmQty = rowsData[i].qty;			// ������Ŀ����
		var ReqRecLoc = rowsData[i].loc;		// ���տ���	
		var ReqRecLocId = rowsData[i].locid;	// ���տ���ID
		if(ReqItmId==undefined)
		{
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"��������ĿΪ�գ�")
			return;
		}	
		if(ReqRecLocId==undefined)
		{
			$.messager.alert("��ʾ","��"+(rowsData.length-i)+"�н��տ���Ϊ�գ�")
			return;
		}			
		var ListData = ReqItmId +"^"+ ItmQty +"^"+ ReqRecLocId +"^"+ REQDisType;
			ListData= ListData +"#"+ RequestDateList;
		ReqdataList.push(ListData);
	} 
	ReqdataList = ReqdataList.join("$$");
	alert(ReqdataList)
	runClassMethod("web.DHCDISGoodsRequest","Save",{"ListData":ReqdataList,"flag":flag},function(jsonString){
		if ((jsonString < 0)&&(jsonString!="-15")){
			$.messager.alert("��ʾ:","�������뷢��ʧ��!��ʧ��ԭ��:"+jsonString);
		}else if(jsonString=="-15"){
			$.messager.alert('��ʾ',"û�а���������Ա�����Ű���Ϣ��"+jsonString);
			return;
			}else{
				var ReqDisIdStr=jsonString;
				//$.messager.alert('��ʾ','����ɹ�');
				SendInfo(ReqDisIdStr)
				clearForm();
				search();
			}
	},'',false)
}

///������Ϣ��΢�Ŷ�
function SendInfo(ReqDisIdStr)
{
	runClassMethod("web.DHCDISGoodsRequest","SenDisInfo",{"ReqDisIdStr":ReqDisIdStr},function(data){
	
	},'',false)
}
/// ɾ��
function deleteRow(){
	select=$('#datagrid').datagrid('getSelected');
	if(null==select){
		$.messager.alert('��ʾ','��ѡ��');
		return;
	}
	var itm="";
	$.messager.confirm('ȷ��', 'ȷ��Ҫɾ����?', function(r){
	if (r){
		itmid="";
		index=$('#datagrid').datagrid('getRowIndex',select);
		$('#datagrid').datagrid('deleteRow',index);
		}
		var rows = $('#datagrid').datagrid('getChanges');
		for(var i=0;i<rows.length-1;i++){
	 	
    		var row = rows[i];
			if(itm=="")
			{
				itm=row.locid;
			}else{
				itm=itm+"^"+row.locid;
			}
		}
		$('#recLoc').combobox({    
    		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itm,    
    		valueField:'id',    
    		textField:'text',
    		mode:'remote'   
		});
	});
	
}

///����
function addRow(){
	if($('#disType').combobox('getValue')==""){
		$.messager.alert("��ʾ","����ѡ����������")
		return;	
	}
	commonAddRow({datagrid:'#datagrid',value:{qty:1}})	
}

///�����¼�
function onClickRow(index,row){
	
	var itmid = row.itmid;
	CommonRowClick(index,row,"#datagrid");
	///���ü���ָ��
	var ed=$("#datagrid").datagrid('getEditor',{index:index,field:'loc'});
	var unitUrl=LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+ itmid;
	$(ed.target).combobox('reload',unitUrl);
}

///������Ŀ��ֵ
function fillValue(rowIndex, rowData)
{
	var itmid = rowData.id;
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'itmid'});			//��ĿID��ֵ
	$(ed.target).val(rowData.id);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex, field:'itm'});				//��Ŀ������ֵ
	$(ed.target).val(rowData.desc);
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'loc'});				//��ȡ��������
	var url=LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=ItmLocCombo&itmid="+itmid;	//���ؿ�����������	
	$(ed.target).combobox('reload',url);										
}

///���Ҹ�ֵ
function fillLocValue(obj){
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'loc'});
	$(ed.target).combobox("setValue",obj.text);  						//���ÿ���ID
	var ed=$("#datagrid").datagrid('getEditor',{index:editIndex,field:'locid'});
	$(ed.target).val(obj.id);  							//���ÿ���ID
	
}

///���
function clearForm(){
	//$('#detail').form('clear');
	$("#disType").combobox('clear');
	$('#datagrid').datagrid('loadData', { total: 0, rows: [] });
	//$("#form").html("")
}

//��ʼ������
function initParam(){
	
	//��;����ȡ��̨����
	$.ajax({
		url:LINK_CSP,
		data:{
			"ClassName":"web.DHCDISAffirmStatus",
	        "MethodName":"GetParamByInit"
		},
		type:'get',
		async:false,
		dataType:'json',
		success:function (data){
			Params = data;    
		}
		})
		
	rowData="";   //ѡ��������ȫ�ֱ���
}

//��ʼ��ʱ���
function initDate(){
	$('#StrDate').datebox("setValue",formatDate(0));
	$('#EndDate').datebox("setValue",formatDate(0));	
}

//��ʼ��datagrid
function initTable(){
	
	var columns = [[
		{
	        field: 'REQ',
	        align: 'center',
            //title: 'mainRowID',
            hidden: true,
            width: 100
	    },  {
	        field: 'REQTypeID',
	        align: 'center',
	        //hidden: true,
            title: '��������ID',
            hidden: true,
            width: 100
	    },{
	        field: 'REQEmFlag',
	        align: 'center',
            title: '�Ӽ���־',
            hidden: true,
            width: 70
	    },{
	        field: 'REQCurStatus',
	        align: 'center',
            title: '��ǰ״̬',
            width: 70
	    }, {
            field: 'REQConfirmUser',
            align: 'center',
            title: '����ȷ����',
            hidden: true,
            width: 50
        },{
            field: 'REQCreateDate',
            align: 'center',
            title: '��������',
            width: 80
        }, {
            field: 'REQCreateTime',
            align: 'center',
            title: '����ʱ��',
            width: 100
        }, {
            field: 'REQLocDr',
            align: 'center',
            hidden: true,
            title: '�������ID',
            width: 80
        },{
            field: 'REQLoc',
            align: 'center',
            title: '�������',
            width: 80
        }, {
            field: 'REQNo',
            align: 'center',
            title: '��֤��',
            hidden:true,
            width: 100  
        }, {
            field: 'REQRecLocDr',
            align: 'center',
            hidden: true,
            title: '���տ���ID',
            width: 160
        }, {
            field: 'REQRecLoc',
            align: 'center',
            title: '���տ���',
            width: 160
        }, { 
            field: 'REQExeDate',
            align: 'center',
            title: '��������',
            width: 100 
        }, { 
            field: 'REQExeTime',
            align: 'center',
            title: '����ʱ��',
            width: 100 
        }, {
            field: 'REQRemarks',
            align: 'center',
            title: '��ע',
            width: 100
        }
        ]]
        
    var param=getParam(); //��ȡ����
    $('#cspAccompStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequest&param='+param,
	    fit:true,
	    rownumbers:true,
	    fitColumns:true,
	    columns:columns,
	    pageSize:20, 		// ÿҳ��ʾ�ļ�¼����
	    pageList:[20,40],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onSelect:function(Index, row){
	        rowData= row;
	    },
	    onUnselect:function (Index, row){
			rowData= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail();
			DisOrConComplete(row);
		},
	})
	$('#cspAccompStatusTb').datagrid({
		rowStyler:function(index,row){
				if(row.REQEmFlag=="Y"){
					return 'color:#EE2C2C'
				}
			}
		
	})
	
	var columnsdetail = [[
		{
	        field: 'ITM',
	        align: 'center',
	        title: '��Ŀ����',
	        width: 250	        
        },/* {
            field: 'RECLOC',
            align: 'center',
            title: 'ȥ��',
            width: 200
        }, */{
            field: 'QTY',
            align: 'center',
            title: '����',
            width: 200
        }
        ]]
		
	$('#cspAccompStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true
    })
    
}
///������ɺ�ȷ����ɰ�ť�����غ���ʾ
function DisOrConComplete(obj)
{
	if(obj.REQRecLocDr == LgCtLocID)
	{
		$("#complete").hide();
		$("#exeBtn").show();
	}else{
			$("#exeBtn").hide();
			$("#complete").show();
		}
}
///������ѯ��ϸ
function ClickRowDetail(){
	var row =$("#cspAccompStatusTb").datagrid('getSelected');
	DisMainRowId=row.REQ; ///��id
	//alert(DisMainRowId)
	$('#cspAccompStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAccompStatus&MethodName=listGoodsRequestItm&req='+DisMainRowId
	});
	Q
	}
	
function initMethod(){
	
     $('#RegNo').bind('keypress',RegNoBlur);		//�س��¼�
     $('#verifiBtn').bind('click',verifiDis); 		//��֤ȷ��
     $('#exeBtn').bind('click',exeDis);       		//����ȷ��
 	 $('#undoBtn').bind('click',Undorequest);      	//��������
 	 $('#printbarcode').bind('click',printbarcode); //��ӡ����
 	 $('#printyfbarcode').bind('click',printyfbarcode); //��ӡ����
 	 $('#complete').bind('click',complete);			//���
 	 $('#GetGoods').bind('click',GetGoods);			//����
 	 $('#givenconfirm').keydown(function (e) {
     if (e.keyCode == 13) {
        afterconfirm();
     }
 	});
 	 
 	 $('#searchBtn').bind('click',search) 			//����	
 	 
 	 $("#appraiseBtn").on('click',function(){
	 	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	 	//dws 2017-02-24 ����Ȩ��
		if((($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="��ǩ��")||(($("#cspAccompStatusTb").datagrid('getSelected').REQCurStatus)=="������")){
			runClassMethod("web.DHCDISAppraise","getAccPeo",{mainRowId:DisMainRowId},function(data){
				if(data==LgUserID){
					createUser=data;
					ScorePages(); //�����۽���
				}
				else{
					$.messager.alert("��ʾ","���뵥�����˲ſ�������!");
				}
			});
			
		}
		else{
			$.messager.alert("��ʾ","��ǩ�����뵥��������!");
		}
	 })
	 
	 $("#particulars").on('click',function(){
	 	ParticularsPages();   					//����
	 })
	 
	 
	 $("#unfiniBtn").on('click',function(){
	 	UndonePages();   						//δ���                  
	 })
	 
	 $("#disitemList").on("click",".checkbox",selectExaItem);    //������Ŀѡ���¼�
	 
	 
}


/*======================================================*/

//�ǼǺŻس��¼�
function RegNoBlur(event){
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("��ʾ","�ǼǺų�����������")
		    $('#RegNo').val("");
		    return;
		    }
		if (Regno!="") {  //add 0 before regno
		    for (i=0;i<Params.regNoLen-oldLen;i++)
		    //for (i=0;i<8-oldLen;i++)
		    {
		    	Regno="0"+Regno 
		    }
		}
	    $("#RegNo").val(Regno);
    }
};

//��ѯ
function search(){
	var Params=getParam(); //��ȡ����
	$('#cspAccompStatusTb').datagrid({
			queryParams:{param:Params}	
	})
	$('#cspAccompStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}

//����ȷ��&����ȷ��
function verifiDis(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	createVertifyWin();
}
function createVertifyWin(){	
	if($('#confirmwin').is(":hidden")){
	   $('#confirmwin').window('open');
		return;
		}           ///���崦�ڴ�״̬,�˳�	
	var option = {
		closed:"true"
	};
	new WindowUX('����ȷ��', 'confirmwin', '300', '180', option).Init();
	
}

///����ȷ��
function afterconfirm()
{
	var StatusCode=13
	
	var EmFlag=rowData.REQEmFlag
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	var UserCode=$('#givenconfirm').val();
	if(UserCode!=LgUserCode)
	{
		$.messager.alert("��ʾ:","���Ŵ���!")
		$('#givenconfirm').val('');
		return;
	}
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":13,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","ȷ�ϳɹ���");
			$('#confirmwin').window('close');
		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

//ǩ��ȷ��
function exeDis(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	if((rowData.REQCurStatus!="���")){			//sufan 2018-03-22 ����ȷ�ϵ�ǰ״̬
			$.messager.alert("��ʾ","�����״̬�����벻����˲�����")
			return;	
		}
	var statuscode="" ;
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")       //sufan 2018-03-22 �������ж�״̬����
	{
		statuscode="103";
	}
	var Relation=""
	var LocaFlag=""
	Relation=$("#currLoca").combobox("getValue");
	if(Relation==""){
		Relation=LgCtLocID;
		LocaFlag="1"
	}else{
		LocaFlag="0"
	}
	var datalist=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID+"#"+EmFlag;
	//alert(datalist)
	$.messager.confirm('����ȷ��','ȷ�Ͻ�������״̬��Ϊ���ȷ����',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":"","Relation":Relation,"RelaFlag":LocaFlag},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","ȷ�ϳɹ���");
						}
					},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData=""
		}	
	})
}

// ��������
function Undorequest(){
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
	}
	var ReqID=rowData.REQ
	var StatusCode=104
	var ReqType=rowData.REQTypeID
	var CurStatus=rowData.REQCurStatus;
	if((CurStatus!="����")){
		$.messager.alert("��ʾ","����״̬�����뵥�ſ��Գ�����");
		return;	
		}
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('ȷ��','��ȷ��Ҫ�����������뵥��',function(r){
		if(r){
			runClassMethod("web.DHCDISRequestCom","CancelApplicaion",{'disreqID':ReqID,'statuscode':StatusCode,'type':ReqType,'lgUser':LgUserID},function(data){
				if(data!=0){
					$.messager.alert("��ʾ",data)
				}else{
					$.messager.alert("��ʾ","�����ɹ���")
				}
			},'text',false)
			$('#cspAccompStatusTb').datagrid('reload');
			rowData="";
		}	
	})
}


//���鵯����ҳ��
function ParticularsPages(mainRowID){
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'����',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.accompdetail.csp?mainRowID='+rowData.REQ+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}


//���ֵ��������
function ScorePages(){
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			title:'����',
			border:true,
			closed:"true",
			width:600,
			height:420,
			collapsible:false,
			minimizable:false,
			maximizable:false,
			resizable:false,
			collapsible:true,
			draggable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 
	
	//iframe ����
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disappraise.csp?mainRowID='+DisMainRowId+'&createUser='+createUser+'&type='+rowData.REQTypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//δ��ɽ��洰��
function UndonePages(){
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
		title:'δ���',
		border:true,
		closed:"true",
		width:600,
		height:400,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcdis.failreason.csp"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');	
}

//Table�������
//return ����ʼʱ��^����ʱ��^����ID^���տ���^�������^״̬
function getParam(){
	var stDate = $('#StrDate').datebox('getValue');
	var endDate=$('#EndDate').datebox('getValue');
	var taskID= $('#TaskID').val();
	var regno = $('#RegNo').val();
	var recLoc = $('#RecLoc').combobox('getValue');
	if(recLoc==undefined){
		recLoc=""
	}
	var applayLocDr= $('#ApplayLoc').combobox('getValue');
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatus').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate + "^" + endDate + "^" + "" + "^" + recLoc + "^" + applayLocDr + "^" + affirmStatus;
}

function printbarcode()
{	
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	var ReqID=rowData.REQ;
	runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
			if((data==-1)||(data==-2)||(data=="")){
				$.messager.alert("��ʾ:","��������!");
				return;
			}else {
					Print(data.split("^")[0]);
				}
		},'text',false)
}

function printyfbarcode()
{
	if((rowData=="")){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	var ReqID=rowData.REQ;
	runClassMethod("web.DHCDISAccompStatus","PrintBarCode",{"ReqID":ReqID},function(data){
			if((data==-1)||(data==-2)||(data=="")){
				$.messager.alert("��ʾ:","��������!");
				return;
			}else {
					Print(data.split("^")[1]);
				}
		},'text',false)
}
///����
function Print(data){	
		       
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCDIS_BarCode"); 
	
	var MyPara="DisCode"+String.fromCharCode(2)+data;
	MyPara=MyPara+"^PrintBarCode"+String.fromCharCode(2)+"*"+data+"*";
	MyPara=MyPara+"^BarCode"+String.fromCharCode(2)+data;
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");	
}

function complete()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	if(EmFlag=="Y")
	{
		$.messager.alert("��ʾ:","�Ӽ���������˲���!");
		return;
	}
	if(rowData.REQCurStatus!="�Ѱ���"){			//sufan 2018-03-22 ����ȷ�ϵ�ǰ״̬
		$.messager.alert("��ʾ:","���Ѱ���״̬������˲���!");
		return;
	}
	var statuscode=""
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	if(TypeID!="18")
	{
		statuscode="102"
	}
	var Relation=""
	var LocaFlag=""
	Relation=$("#currLoca").combobox("getValue");
	if(Relation==""){
		Relation=LgCtLocID;
		LocaFlag="1"
	}else{
		LocaFlag="0"
	}
	var datastr=ReqID+"#"+TypeID+"#"+statuscode+"#"+LgUserID;
	//alert(datastr)
	runClassMethod("web.DHCDISGoodsRequest","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":statuscode,"lgUser":LgUserID,"reason":"","Relation":Relation,"RelaFlag":LocaFlag},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");

		}else{
			$.messager.alert('����',jsonString);
			return;
		}
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
				
}

///�ж��ǿ��һ���תվ
function isCtLoc()
{
	var flag="";
	runClassMethod("web.DHCDISGoodsRequest","isCtLoc",{"LocDr":LgCtLocID},function(jsonString){
		flag=jsonString;
	},'text',false);
	return flag;
}

function GetGoods()
{
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var EmFlag=rowData.REQEmFlag;
	var ReqID=rowData.REQ;
	var TypeID=rowData.REQTypeID
	runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":ReqID,"type":TypeID,"statuscode":14,"lgUser":LgUserID,"EmFlag":EmFlag,"reason":""},function(jsonString){
		if (jsonString==0){
			$.messager.alert("��ʾ","����ɹ���");

		}else{
			$.messager.alert('����',jsonString);
			return;
		}s
	},'text');
	$('#cspAccompStatusTb').datagrid('reload');
	rowData="";
}

///Ĭ�ϵ�ǰ����
function initDisTime()
{
	var now=new Date();			// ��ǰ����
	var y = now.getFullYear();	// ��
	var m = now.getMonth()+1;   // ��       
	var d = now.getDate(); 		// ��
	if (m<=9)
	{
		var m="0"+m;
		}
	if (d<=9)
	{
		var d="0"+d;
		}
	var hours = now.getHours();		// ʱ
	var minutes = now.getMinutes(); // ��
	var seconds	= now.getSeconds(); // ��
	if (hours <= 9)
	{
		var hours="0" + hours;
		}
	if (minutes <= 9)
	{
		var minutes="0" + minutes;
		}
	if (seconds <= 9)
	{
		var seconds="0" + seconds;
		}
	var time = hours +":"+ minutes +":"+ seconds;
	var startdate = y + "-" + m + "-" + d;
	var nowtime = startdate +" "+ time;
	$("#exeDate").datetimebox("setValue",nowtime);	// ���ñ걾�̶�ʱ��
}
/// ����������Ŀ�б�
function LoadCheckItemList(typeId){
	/// ��ʼ����鷽������
	$("#disitemList").html('<tr><td style="width:20px"></td><td></td><td style="width:20px;"></td><td></td></tr>');
	runClassMethod("web.DHCDISCommonDS","getDisItemByTypeId",{"TypeId":typeId},function(jsonString){
		if (jsonString != ""){
			
			var jsonObjArr = jsonString;
			for (var i=0; i<jsonObjArr.length; i++){
				InitCheckItemRegion(jsonObjArr[i]);
			}
		}
	},'json',false)
}

/// ��鷽���б�
function InitCheckItemRegion(itemobj){	
	var htmlstr = '';
	var itemArr = itemobj.items;
	var itemhtmlArr = []; itemhtmlstr = "";
	for (var j=1; j<=itemArr.length; j++){
		
		itemhtmlArr.push('<td style="height:25px;"><input id="'+ itemArr[j-1].value +'" name="ExaItem" type="checkbox" style="margin-left:10px;" class="checkbox" value="'+ itemobj.id +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
		if (j % 2 == 0){
			itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '</tr>';
			itemhtmlArr = [];
		}
	}
	if ((j-1) % 2 != 0){
		itemhtmlstr = itemhtmlstr + '<tr>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
		itemhtmlArr = [];
	}
	$("#disitemList").append(htmlstr+itemhtmlstr)
}
function selectExaItem()
{
	if ($(this).is(':checked')){
		var DisItmId = this.id;					/// ������ĿId
		var DisItmDesc = $(this).parent().next().text(); 	/// ������Ŀ
		var ItemLocID="",ItemLoc="";
		runClassMethod("web.DHCDISCommonDS","ItmLocCombo",{"itmid":DisItmId},function(jsonString){
			if (jsonString != ""){
				var jsonObjArr = jsonString;
				ItemLocID = jsonObjArr[0].id;
				ItemLoc = jsonObjArr[0].text;
			}
		},'json',false)	
		if(ItemLocID=="")
		{
			$.messager.alert("��ʾ","���տ���Ϊ��");
			return false;
		}
		var rowobj={itmid:DisItmId, itm:DisItmDesc, qty:"1", loc:ItemLoc, locid:ItemLocID}
		$("#datagrid").datagrid('appendRow',rowobj);
	}else{
		
	   	
	   }
}