/// Creator: huaxiaoying
/// CreateDate: 2017-01-19
var requested=0 //�����Ƿ�������
var SelByAdm="" //���������һ���
var rowDataS="" 
var PatAdm="";  //����ID   add by sufan ѡ���ˣ���������������棬Ĭ��ѡ���ڴ�λͼѡ�еĲ��ˣ����ڴ����˵ľ����
$(document).ready(function() {
	
	
	PatAdm = getParam("EpisodeID");			// ȡ��λͼ��ѡ���˵ľ����
	$HUI.checkbox("#Adm",{
		onCheckChange:function(e,value){
			 var Ord = $('#DisReqOrdTb').datagrid('getRows');
	         if (Ord) {
	             for (var i = Ord.length - 1; i >= 0; i--) {
	                 var index = $('#DisReqOrdTb').datagrid('getRowIndex', Ord[i]);
	                 $('#DisReqOrdTb').datagrid('deleteRow', index);
	             }
	         }
	        $('#DisReqOrdTb').datagrid('loadData', { total: 0, rows: [] });
			if($('#Adm').is(':checked')){
				SelByAdm="EO;"
				rowData="";
				GetSearchInfo()
				hideControl();
			}
			else
			{
				SelByAdm=""
				GetSearchInfo();
				hideControl();
			}	
		}	
	});
	
	initDate();  		//��ʼ�����ڿ�
	initCombo();		//��ʼ��combo
	initMethod();  		//��ʼ���ؼ��󶨵��¼�
	initDatagrid(); 	//��ʼ��datagrid
	initdistable(); 	//��ʼ�����뵥
	$('#regNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            regNoBlur()
        }
    });
    //ҽ�����Ʋ���
    $('#OrdName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#DisReqOrdTb','formid':'#queryForm'}); //���ò�ѯ
        }
    });
    //�������Ʋ���
    $('#OthName').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            commonQuery({'datagrid':'#DisReqOthTb','formid':'#queryFormOth'}); //���ò�ѯ
        }
    });
    //$('#Adm').click(function({}))

	
	//ҽ��/����ֻѡ��һ��
	$('#tab').tabs({      
        onSelect:function(title){    
	        if(title=="ҽ��"){
		       //����
			    $('#DisReqOthTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
				});	
	        }else{
		        $('#DisReqOrdTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListOrd&EpisodeID='+PatAdm
				});	
		        //����
			    $('#DisReqOthTb').datagrid({    
					url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
				});	
		    }
	    }    
	});
	$('#PatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
           
			var PatNo=$("#PatNo").val();
			$('#PatNo').val(getpatno(PatNo));
			GetSearchInfo();
			
        }
    });
    $('#PatNoSearch').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
           
			var PatNo=$("#PatNoSearch").val();
			$('#PatNoSearch').val(getpatno(PatNo));
			GetSearchInfo();
			
        }
    });
    
	$('#DisReqOrdTb').datagrid('loadData', {total:0,rows:[]});
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
})

/// ��ȫ�ǼǺ�λ��
function getpatno(patno)
{
	var patnolen=patno.length;
	var len=10-patnolen
	for (var i=0;i<len;i++)
	{
		patno="0"+patno;
		}
	if(patno=="0000000000"){
		patno="";
	}
	return patno;
}
function initDatagrid()
{
	if(LocDesc.indexOf("��������") != "-1")
	{
		initPatform();
		initPatList();
	}else{
		initform(); //��ʼ����¼���
		inittable(); //��ʼ��table �����б�
		$HUI.checkbox("#Adm").disable();
		$HUI.combobox("#VisLoc").setValue(LgCtLocID);
		$HUI.combobox("#VisLoc").disable()
		}
}
//��ʼ��combobox
function initCombo(){
	$('#ApplayLocS').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' 
	});
	
	$('#AffirmStatusS').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=StatusCombo&type="+0,// type 0: ���� ,1: ����
		valueField:'id',
	    textField:'text',
	    onSelect:function(record){
		},
	});
	var code=""
	if(LocDesc.indexOf("��������") != "-1")
	{
		code=11;
	}else{
			code=10;
		}
	runClassMethod("web.DHCDISRequest","getStatusValue",{'code':code},function(data){
		$('#AffirmStatusS').combobox("setValue",data);
	},'text',false)
	
	///��ʼ��������Ա������
	$('#Escortper').combobox({
		url:'', //LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID,
		valueField:'value',
	    textField:'text',
	    mode:'remote',
	    onShowPanel: function () { //���ݼ�������¼�
			///���ü���ָ��
			var unitUrl = LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID;
			$("#Escortper").combobox('reload',unitUrl);
        }
	    
	});

}
///Ĭ������ʱ�� zwq
function InitDateTimeBox()
{
	$("#StartDate").datebox("setValue",formatDate(0));   ///��������
	
	
}
///��ʼ�����뵥�б�
function initdistable()
{
	var columns = [[
		
		{
	        field: 'ck',
	        checkbox:'true',
	        //align: 'center',
            
	    },{
	        field: 'patname',
	        //align: 'center',
            title: '����'
	    },
	    {
	        field: 'hosno',
	        //align: 'center',
            title: 'סԺ��'
	    },
     	{
	        field: 'mainRowID',
	        //align: 'center',
	        hidden: true,
            title: '���뵥ID'
	    },{
	        field: 'newStatus',
	        //align: 'center',
            title: '��ǰ״̬'
	    },{
	        field: 'TypeID',
	        //align: 'center',
	        hidden: true,
            title: '����ID'
	    },{
            field: 'applyDate',
            //align: 'center',
            title: '��������'
        }, {
            field: 'currregNo',
            //align: 'center',
            title: '�ǼǺ�'
        }, {
            field: 'bedNo',
            //align: 'center',
            title: '����'
        }, {
            field: 'endemicArea',
            //align: 'center',
            title: '����'
        }, {
            field: 'taskID',
            //align: 'center',
            title: '��֤��',
            hidden: true
        },{
            field: 'acceptLoc',
            //align: 'center',
            title: '���տ���',
            hidden: true
        },{
            field: 'dispeople',
            //align: 'center',
            title: '������Ա'
        }, { 
            field: 'deliveryDate',
            //align: 'center',
            title: '��������'
        },  {
            field: 'deliveryWay',  
            //align: 'center',
            title: '���ͷ�ʽ'
        }, {
            field: 'deliveryType',
            //align: 'center',
            title: '��������'
        }, 
       {
            field: 'remarkDesc',
            //align: 'center',
            title: '��ע'
        }, {
            field: 'nullFlag',
            //align: 'center',
            title: '����',
            hidden: true
        }, {
            field: 'AssNumber',
            //align: 'center',
            title: '����',
        }, {
            field: 'AssRemarks',
            //align: 'center',
            title: '����',
           
        }
        ]]
    var param=getinParam(); //��ȡ����
    var rowData=$('#DisReqPatTb').datagrid('getSelected');  //��ȡ���߾���ID
    var AdmNo="";
    if(rowData!=null)
    {
	    AdmNo=rowData.Adm;
	}
    $('#cspAffirmStatusTb').datagrid({
	    url:LINK_CSP+'?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdEscort&param='+param+'&PatLoc='+LgCtLocID+'&AdmNo='+AdmNo+'&HospID='+LgHospID,
	    fit:true,
	    rownumbers:true,
	    //fitColumns:true,
	    columns:columns,
	    pageSize:100, // ÿҳ��ʾ�ļ�¼����
	    pageList:[100,200],   // ��������ÿҳ��¼�������б�
	    //singleSelect:true,
	    loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    onSelect:function(Index, row){
		    ClickRowDetail(row.mainRowID);
	        rowDataS= row;
	    },
	    onUnselect:function (Index, row){
			rowDataS= "";
		},
		onClickRow:function(Index, row){
			ClickRowDetail(row.mainRowID);
		},
		onLoadSuccess: function () {   //���ر�ͷ��checkbox
           //$("#cspAffirmStatusTb").parent().find("div .datagrid-header-check").children("input[type=\"checkbox\"]").eq(0).attr("style", "display:none;");
        	
        }
	})
	
	var columnsdetail = [[
		{
	        field: 'projectName',
	        //align: 'center',
	        title: '��Ŀ����',
	        width: 250	        
        },{
            field: 'toBourn',
            //align: 'center',
            title: 'ȥ��',
            width: 200
        }
        ]]
		
	$('#cspAffirmStatusCarefulTb').datagrid({
		columns:columnsdetail,
	    pageSize:20,
	    pageList:[20,40],
        singleSelect:true,
        loadMsg: '���ڼ�����Ϣ...',
	    pagination:true,
	    nowrap:false//�����Զ�����
    })
}

//��ѯ��Ŀ��ϸ
function ClickRowDetail(DisMainRowId){
	//var row =$("#cspAffirmStatusTb").datagrid('getSelected');
	//DisMainRowId=row.mainRowID; //����id
	$('#cspAffirmStatusCarefulTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrdDetail&DisMainRowId='+DisMainRowId
	});
	
}
function getinParam(){
	var stDate = $('#StrDateS').datebox('getValue');
	var endDate=$('#EndDateS').datebox('getValue');
	var taskID= $('#TaskIDS').val();
	var regno = $('#RegNoS').val();
	var applayLocDr= $('#ApplayLocS').combobox('getValue');
	var DisHosNo = $('#HosNoS').val();
	if(applayLocDr==undefined){
		applayLocDr=""		
	}
	var affirmStatus = $('#AffirmStatusS').combobox('getValue');
	if(affirmStatus==undefined){
		affirmStatus=""		
	}
	return stDate+"^"+endDate+"^"+taskID+"^"+regno+"^"+applayLocDr+"^"+affirmStatus+"^"+DisHosNo;
}
///��ʼ�����ڿ�
function initDate()
{
	$('#StrDateS').datebox("setValue",formatDate(0));
	$('#EndDateS').datebox("setValue",formatDate(0));
	$("#StDate").datebox("setValue",formatDate(0));	 	 ///��ʼ����
	$("#EndDate").datebox("setValue",formatDate(0));	 ///��������
}
// ��ʼ��ť�󶨷���
function initMethod(){
	 $('#save').bind('click',save);
	 //�س��¼�
     $('#RegNoS').bind('keypress',RegNoBlur);
     $('#search').bind('click',GetSearchInfo)  		//���һ����б�
     $('#exeBtn').bind('click',DisAffirm);       	//����ȷ��
     $("#undoBtn").bind('click',Undorequest)		//��������
 	 $('#searchBtn').bind('click',search) 			//����
 	 //$('#nullflagBtn').bind('click',SetNullFlag)  //���ÿ��˱�ʶ
 	 $('#requestCopy').bind('click',RequestCopy) 	//������������
 	  $("#detailsbtn").bind('click',ParticularsPages) //����
 	 
 	 $("#appraiseBtn").on('click',function(){
		if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
		//dws 2017-02-24 ����Ȩ��  
		if((($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="���ȷ��")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="������")||(($("#cspAffirmStatusTb").datagrid('getSelected').newStatus)=="����")){
			
			appraise(); //�����۽���
		}
		else{
			$.messager.alert("��ʾ","�����ȷ�����뵥��������!");
		}
	 })
	 
}
//�ǼǺŻس��¼�
function RegNoBlur(event)
{
    if(event.keyCode == "13")    
    {
        var i;
	    var Regno=$('#RegNo').val();
	    var oldLen=Regno.length;
	    if (oldLen>Params.regNoLen){
		    $.messager.alert("��ʾ","�ǼǺų�����������");
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
}
//��ѯ
function search(){
	/*if(LocDesc!="���ڹ���������"){
		var AdmSelectRow=$('#DisReqPatTb').datagrid('getSelected');
		if(AdmSelectRow==null)
		{
			$.messager.alert("��ʾ:","��ѡ����!");
			return;
		}
	}*/
	var AdmNo="";  //��ȡ���߾���ID 
	var Params=getinParam(); //��ȡ����
	$('#cspAffirmStatusTb').datagrid({
			queryParams:{"param":Params,"PatLoc":LgCtLocID,"AdmNo":AdmNo,HospID:LgHospID}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
	
}
///ҽ���ĵ����¼� �漰���տ��� 2017-02-24
function onClickOrdRow(rowIndex, rowData){
	var lenOrd=$("#DisReqOrdTb").datagrid('getSelections').length;
	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	if(lenOth>0)
	{
		$.messager.alert("��ʾ:","��ѡ��������Ŀ��������ѡ��ҽ��!");
		$(this).datagrid('unselectRow', rowIndex);
		return;
	}
	if(lenOrd>0)
	{
		$('#RecLoc').combobox('setValue',"");
	}
	setDisReqWay();
}

///ҽ���ĵ����¼� �漰���տ��� 2017-05-05   zhl
function onUnClick(rowIndex, rowData){
	//deleteon(rowData,rowIndex);
	len=$("#DisReqOrdTb").datagrid('getSelections').length;
	if(len<1)
	{
		$("#RecLoc").combobox("setValue","");
	}
}

///zhlҽ���ĵ����¼�
function deleteon(rowData,rowIndex){
      var data = $('#DisReqSelectedProjectTb').datagrid('getData');
      for(var i=0;i<data.rows.length;i++){
            var row = data.rows[i].Index;
            if(rowIndex==row){
	            var Index = $('#DisReqSelectedProjectTb').datagrid('getRowIndex', data.rows[i]);
	            $('#DisReqSelectedProjectTb').datagrid('deleteRow', Index); 
            }
        }
}

///zhlҽ���ĵ����¼�
function insertd(rowData,rowIndex) {
               $('#DisReqSelectedProjectTb').datagrid("insertRow", { 
                       //���ﻹ��һ��index��������ָ����ӵ�ĳ�С������д��Ĭ��Ϊ�����һ�����
                   row: {
                         ReqDesc:rowData.arcItmDesc,
                         ExelocDesc:rowData.recLoc,
                         Index:rowIndex   
                   }
               });
}
function onClickOthRowWuNai(rowIndex, rowData)  //��������   �ù¶�  ?.?
{
	$.messager.alert("��ʾ:","��ѡ��ҽ��,������ѡ��������Ŀ!");
	onClickOthRowWuNai(rowIndex, rowData);
}
///�����ĵ����¼� �漰���տ��� 2017-02-23
function onClickOthRow(rowIndex, rowData){
	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	if(len>0)
	{
		$.messager.alert("��ʾ:","��ѡ��ҽ��,������ѡ��������Ŀ!");
		$(this).datagrid('unselectRow', rowIndex);
		return;
	}
	setDisReqWay();
	
	if(rowData.TypeFlag==3){
		$("#ReqWay").combobox("setValue",'')
	}
}

///ҽ���ĵ����¼� �漰���տ��� 2017-05-05   zhl
function onUnClicki(rowIndex, rowData){
	//deleteoni(rowData,rowIndex)	
	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	if(lenOth==0)
	{
		$("#RecLoc").combobox("setValue",'');
	}
}

///zhlҽ���ĵ����¼�
function deleteoni(rowData,rowIndex){
      var data = $('#DisReqSelectedProjectTb').datagrid('getData');
      for(var i=0;i<data.rows.length;i++){
            var row = data.rows[i].Indexi;
            if(rowIndex==row){
	            var Indexi = $('#DisReqSelectedProjectTb').datagrid('getRowIndex', data.rows[i]);
	            $('#DisReqSelectedProjectTb').datagrid('deleteRow', Indexi); 
            }
        }
}
///zhl�����ĵ����¼�
function insert(rowData,rowIndex) {
               $('#DisReqSelectedProjectTb').datagrid("insertRow", { 
                       //���ﻹ��һ��index��������ָ����ӵ�ĳ�С������д��Ĭ��Ϊ�����һ�����
                   row: {
                         ReqDesc:rowData.LIDesc,
                         ExelocDesc:rowData.LIlocDesc,
                         Indexi:rowIndex 
                   }
               });
}

///���㷽��
function regNoBlur()
{   
	var i;
    var regNo=$('#regNo').val();
    var oldLen=regNo.length;
    if (oldLen==10) return;
	if (regNo!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regNo="0"+regNo 
	    }
	}
    $("#regNo").val(regNo);
}
///����
function save(){
	if(requested==1){
		$.messager.alert("��ʾ","��������[�����б�]���������˺���д���벢���棡");
		return;
	}                
	var regNo=$('#regNo').val();
	var BedId=$('#BedId').val();//
	var bedNo=$('#bedNo').val();
	var wardId=$('#wardId').val();//
	var ward=$('#ward').val();
	var jobId=$('#jobId').val();
	var RecLoc=$('#RecLoc').combobox('getValue');
	var Date=$('#StartDate').datebox('getValue');
	
	var DateFlag=serverCall("web.DHCDISRequest","JudgeDate",{"Date":Date})
	var TimePoint=$('#Time').combobox('getText');

	var TimeValue=$('#Time').combobox('getValue');
	var TimeFlag=serverCall("web.DHCDISRequest","JudgeTime",{"Date":Date,"Time":TimePoint})
	//var TimePoint=$('#TimePart').combobox('getText');
	var Time=""
	var StartDate=Date+" "+Time+" "+TimePoint
	var ReqType=$('#ReqType').combobox('getValue');
	var ReqWay=$('#ReqWay').combobox('getValue');
	var ReqNum=1;
	var note=$('#note').val()
	note = note.replace(/\^/g,'');
	var EscortPer=$("#Escortper").combobox("getValue")	//��ȡ����ID sufan   2018-01-02
	var EpisodeID=$('#EpisodeID').val();
	var Othsel=$("#DisReqOthTb").datagrid('getSelections');  //ѡ��������Ŀ�Ǳ���ѡ�����  zwq
	var lenOth=Othsel.length;
	var ReqTypeText=$('#ReqType').combobox('getText');
	var ReqWayText=$('#ReqWay').combobox('getText');
	if(regNo==""){
		$.messager.alert("��ʾ","�뵥�������б����Զ�����ǼǺţ�");//����д�ǼǺţ�
	}
	else if(jobId==""){
		$.messager.alert("��ʾ","�뵥�������б����Զ���������ID��");
	}else if((lenOth!=0)&&(RecLoc=="")&&(Othsel[0].RecLocFlag=="Y")){
		$.messager.alert("��ʾ","��ѡ����տ��ң�");
	}else if(Date==""){
		$.messager.alert("��ʾ","��ѡ����������!");
	}else if((DateFlag==0)&&(LocDesc.indexOf("��������") ==-1)){
		$.messager.alert("��ʾ","��������С�ڵ�ǰ����!");
	}else if(TimePoint==""){
		$.messager.alert("��ʾ","��ѡ������ʱ�䣡"); 
	}else if(TimeValue==undefined){
		$.messager.alert("��ʾ","ʱ���ʽ����,��ѡ������ʱ�䣡"); 
	}else if((ReqWay=="")||(ReqWayText=="")){
		$.messager.alert("��ʾ","��ѡ�����ͷ�ʽ��");
	}else if(ReqWay==undefined){
		$.messager.alert("��ʾ","���ͷ�ʽ��������,��ѡ�����ͷ�ʽ��");
	}else if((TimeFlag==0)&&(LocDesc.indexOf("��������") =="-1")){
		$.messager.alert("��ʾ","����ʱ��С�ڵ�ǰʱ��!");
	}else if(ReqNum==""){
		$.messager.alert("��ʾ","��ѡ������������");
	}else if((ReqType=="")||(ReqTypeText=="")){
		$.messager.alert("��ʾ","��ѡ���������ͣ�");
	}else if(ReqType==undefined){
		$.messager.alert("��ʾ","����������������,��ѡ���������ͣ�");
	}else if((EscortPer=="")&&(LocDesc.indexOf("��������") != "-1")){
		$.messager.alert("��ʾ","��ѡ��������Ա��");
	}else{
		var str=jobId+"^"+wardId+"^"+BedId+"^"+EpisodeID+"^"+regNo+"^"+RecLoc+"^"+StartDate+"^"+ReqType+"^"+ReqWay+"^"+ReqNum+"^"+note+"^"+LgCtLocID+"^"+UserID+"^"+LgHospID //+"^"+Item+"^"+ItemType+"^"+ExeLocDr
		var strObjs="" //��Ŀ��
		var rows =$("#DisReqOrdTb").datagrid('getSelections');
		var rowsOth =$("#DisReqOthTb").datagrid('getSelections');
		if ((rows.length==0)&&(rowsOth.length==0)) {
			 $.messager.alert("��ʾ",'��ѡ����Ŀ��(ҽ��/����)��'); 
			 return  
	    }else{
			for(var i = 0; i<rows.length;i++){
				strObjs=strObjs+rows[i].arcItmId+"^"+rows[i].Type+"^"+rows[i].recLocID+"$$"
			}
			for(var j = 0; j<rowsOth.length;j++){
				strObjs=strObjs+rowsOth[j].ID+"^"+rowsOth[j].Type+"^"+rowsOth[j].LIlocDr+"$$"
			}
	    }
	    runClassMethod("web.DHCDISRequest","isReqItmRepeat",{'str':str,'strObjs':strObjs},
			function(data){
				if(data=="")
				{
					$.messager.confirm('ȷ��','��ȷ�ϱ��������������',function(r){   
		   			 if (r){
								SaveRep(strObjs,str,EscortPer)     ///���ñ��溯��
		    				}
		   				 })	
				}else{
	 				$.messager.confirm('ȷ��','<font style="color:red">'+data+'</font>'+'�Ѿ�������Ƿ������룿',function(r){   
		   			 if (r){
								SaveRep(strObjs,str,EscortPer)     ///���ñ��溯��
		    				}
		   				 })		
	 				}		
			},"text",false)
		}   
	
}
///�������������
function SaveRep(strObjs,str,EscortPer)
{
	runClassMethod("web.DHCDISRequest","Save",
	    {'str':str,
	     'strObjs':strObjs},
			function(data){
				if(data<0)
				{
                	$.messager.alert("��ʾ","����ʧ��");  //sufan  2017-11-23 
				}else{
	 			
	 				AutoArrangement(data,EscortPer);
                	search();
                	$('#DisReqOrdTb').datagrid('load');
                	$('#DisReqOthTb').datagrid('load');
                	//$('#DisReqpatReqedTb').datagrid('load');
                	var Params=getinParam(); //��ȡ����
					$('#cspAffirmStatusTb').datagrid({
						queryParams:{param:Params,AdmNo:PatAdm}	
					})
	 			}	
			},"text",false)
}

///��ʼ����¼���
function initform(){
	$('#VisLoc').combobox({ //�������    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(option){
	        //GetSearchInfo();
	    }       
	});
	$('#RecLoc').combobox({ //���տ���    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(){
	    	
	    	var Othsel=$("#DisReqOthTb").datagrid('getSelections');
	    	var lenOth=Othsel.length;
	    	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	    	
	    	if(len==0)
	    	{
				if(lenOth==0)
	    		{
		    		$('#RecLoc').combobox('setValue',"");
		    		$.messager.alert("��ʾ:","����ѡ��������Ŀ!");
		    		return;
		    	}else if(Othsel[0].RecLocFlag!="Y")
		    		{
			    		 $('#RecLoc').combobox('setValue',"");
			    	}
		    }
		    else
		    {
			   $('#RecLoc').combobox('setValue',"");
		    	//$.messager.alert("��ʾ:","��ѡ��ҽ����Ŀ������ѡ����տ���!");
		    	return; 
			}
	    }
    
	});  

	$('#ReqType').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#ReqWay').combobox({ //���ͷ�ʽ 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#Time').combobox({ //����ʱ�� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	/* $('#TimePart').combobox({ //����ʱ��� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	}); */
	/*$('#ReqNum').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",    
	    valueField:'id',    
	    textField:'text',
	    onSelect: function () {
				//��ȡѡ�е�ֵ
				var varSelect = $(this).combobox('getValue');
				runClassMethod("web.DHCDISRequest","GetNowReqNum",
			    {Loc:varSelect},
				function(data){
					if(data<varSelect){
						$.messager.alert("��ʾ","��ǰ��������Ϊ "+data+" ��!");
					}
				});	
								
		}  
	});*/

}
/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	if(SelByAdm=="")
	{
		var BedInfo=rowData.PatBed;
		if(BedInfo!=""){BedInfo=BedInfo+"��"}
		else{BedInfo="�Ⱥ���"}
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;"><span style="color:red;">' + BedInfo+'</span></h3><h3 style="margin-left:5px;float:left;background-color:transparent;">'+ rowData.PatName + '</h3><br>';
	} 
	else
	{
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.PatName + '</h3><br>';
	} 
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}
/// ������Ϣ�б�  ��Ƭ��ʽ ������
function setReqedCellLabel(value, rowData, rowIndex){
	var htmlstr =  '<div class="celllabel"><h3 style="float:right;background-color:transparent;"><span style="color:red;">'+ rowData.PatBed+"��"+'</span></h3><h3 style="margin-left:5px;float:left;background-color:transparent;">'+ rowData.PatName +'</h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;">ID:'+ rowData.PatNo +'</h4>';

		if(rowData.NurseLevel!=""){
			htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"></h4>';
		}
		htmlstr = htmlstr +'<h3 style="float:left;color:#000;background-color:transparent;">'+ rowData.CreateDate +'</h3>';
		htmlstr = htmlstr +'<h3 style="float:left;color:red;background-color:transparent;">'+ rowData.ExeDate +'</h3>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}
///���form��
function clearForm(){
	//�ı���
	/*$('input:text[id]').not('.combobox-f').not('.datebox-f').each(function(){
		$("#"+ this.id).val("");
	})*/
	// Combobox
	/*$('input.combobox-f').each(function(){
		$("#"+ this.id).combobox("setValue","");
	})*/
	// ����ʱ��
	$('input.datetimebox-f').each(function(){
		$("#"+ this.id).datetimebox("setValue","");
	})
	$("#EpisodeID").val("");
	$("#BedId").val("");
	$("#wardId").val("");
}
//���Ҷ�Ӧ�������뵥
function selAdmReq(rowData)
{
	var Params=getinParam(); //��ȡ����
	
	$('#cspAffirmStatusTb').datagrid({
		queryParams:{param:Params,AdmNo:rowData.Adm}	
	})
	$('#cspAffirmStatusCarefulTb').datagrid('loadData', {total:0,rows:[]})
}
///table��дurl
function rewTbUrl(rowData){
	//��ѡ��Ŀ
	/* $('#DisReqSelectedProjectTb').datagrid({  
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListSelected&AdmNo='+rowData.Adm
	});	 */
    //ҽ��
  
    $('#DisReqOrdTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListOrd&EpisodeID='+rowData.Adm
	});	
	
    //����
    $('#DisReqOthTb').datagrid({    
		url:'dhcapp.broker.csp?ClassName=web.DHCDISRequest&MethodName=ListLocItem&LgHospID='+LgHospID
	});	
	/* //���뵥�б�
	$('#cspAffirmStatusTb').datagrid({
		url:'dhcapp.broker.csp?ClassName=web.DHCDISAffirmStatus&MethodName=GetDisListOrd&param='+param+'&AdmNo='+rowData.Adm
	}); */
}
///��ֵform��
function setForm(rowData){
	setDisReqType();
	setDisReqWay();
	//$('#ReqNum').combobox("setValue","1");   //Ĭ�ϻ�������
	InitDateTimeBox();  //Ĭ��datetimebox��ֵ
	var regNo=$('#regNo').val(rowData.PatNo);
	var bedNo=$('#bedNo').val(rowData.PatBed);
	var ward=$('#ward').val(rowData.AdmWard); 
	var wardId=$('#wardId').val(rowData.AdmWardDr);
	var EpisodeID=$('#EpisodeID').val(rowData.Adm); 
	var BedId=$('#BedId').val(rowData.BedId);
	var type=0
	runClassMethod("web.DHCDISRequest","getVerfiyCode",
			    {'type':type},
				function(data){
					var jobId=$('#jobId').val(data);
	},'text');			
	///���
	$HUI.combobox("#RecLoc").setValue("");
	InitDateTimeBox();
	$HUI.combobox("#Time").setValue("");
	$("#note").val("");
	$HUI.combobox("#Escortper").setValue("");
}
/// sufan 2017-11-28 ��̬�����ͷ�ʽ����Ĭ��ֵ
function setDisReqWay()
{
	runClassMethod("web.DHCDISRequest","DisToolList",{"HospID":LgHospID},function(jsonString){
		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ReqWay").combobox('loadData',jsonString);   	// ���ؽ��տ���combobox������
			for(var i=0;i<jsonObjArr.length;i++){
				$("#ReqWay").combobox('select', jsonObjArr[0].id);	
			}     
		}
	},'json',false)
}
/// sufan 2017-11-28 ��̬��������������Ĭ��ֵ
function setDisReqType()
{
	runClassMethod("web.DHCDISRequest","DisTypeList",{"HospID":LgHospID},function(jsonString){
		if (jsonString != null){
			var jsonObjArr = jsonString;
			$("#ReqType").combobox('loadData',jsonString);   	// ���ؽ��տ���combobox������
			for(var i=0;i<jsonObjArr.length;i++){
				$("#ReqType").combobox('select', jsonObjArr[0].id);	
			}     
		}
	},'json',false)
}
///��ֵform��(�������б�ֵ)
function setFormShow(rowData){
	var regNo=$('#regNo').val(rowData.PatNo);
	var bedNo=$('#bedNo').val(rowData.PatBed);
	var ward=$('#ward').val(rowData.REQWard); 
    var jobId=$('#jobId').val(rowData.REQNo); 
	var note=$('#note').val(rowData.Remarks);
	// Combobox
	$("#RecLoc").combobox("setValue",rowData.REQRecLocDr);
	$("#ReqType").combobox("setValue",rowData.EscortTypeDr);
	$("#ReqWay").combobox("setValue",rowData.EscortToolDr);
	//$("#ReqNum").combobox("setValue",rowData.Nums);
	// ����ʱ��
	$("#StartDate").datetimebox("setValue",rowData.ExeDate);
}
///��ʼ��table
function inittable(){

	//�����б�
	// ����columns
	var columns=[[
		{field:'PatLabel',title:'Ԥ�����',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'�ǼǺ�',width:100,hidden:true},
		{field:'PatName',title:'����',width:100,hidden:true},
		{field:'PatBed',title:'����',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'�Ա�',width:100,hidden:true},
		{field:'Adm',title:'����ID',width:100,hidden:true},
	]];
	var LocID=LgCtLocID;	///sufan 2018-01-02  ����̨��session��Ϊjs��ֵ
	var WardID=wardId		//ssion['LOGON.WARDID'];	
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=SelByAdm&SelByAdm="+SelByAdm+"&LocID="+LocID+"&WardID="+WardID,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    pagination:true,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        PatAdm=rowData.Adm ;   //sufan 2017-12-03
	        clearForm();//���form��
	        setForm(rowData);//��ֵform��
	        rewTbUrl(rowData);//table��дurl
	        selAdmReq(rowData);//���Ҷ�Ӧ�������뵥
	        requested=0;//�����Ƿ�������
	    },
		onLoadSuccess:function(data){
			// ���ط�ҳͼ��
            //$('#List .pagination-page-list').hide();
            var rows = $("#DisReqPatTb").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].Adm==PatAdm)
	            {
		            $('#DisReqPatTb').datagrid('selectRow',i);
		            clearForm();//���form��
	        		setForm(rows[i]);//��ֵform��
	        		rewTbUrl(rows[i]);//table��дurl
	        		selAdmReq(rows[i]);//���Ҷ�Ӧ�������뵥
	        		requested=0;//�����Ƿ�������
				}
	         }
            $('#List .pagination-info').hide();
            
            
		}
	});
	//����ˢ��
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false}); 
    
    //�������б�
	// ����columns
	var columns=[[
		{field:'PatLabel',title:'Ԥ�����',width:190,formatter:setReqedCellLabel},
		{field:'PatNo',title:'�ǼǺ�',width:100,hidden:true,},
		{field:'PatName',title:'����',width:100,hidden:true},
		{field:'PatBed',title:'����',width:100,hidden:true},
		{field:'CreateDate',title:'CreateDate',width:100,hidden:true},
		{field:'ExeDate',title:'ExeDate',width:100,hidden:true}
	]];
	$('#DisReqpatReqedTb').datagrid({
		
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=listRequest",
		fit:true,
	    border:false,
		rownumbers:true,
		columns:columns,
		pageSize:10,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		showHeader:false,
		rownumbers : false,
		showPageList : false,
        onClickRow:function(rowIndex, rowData){
	        clearForm();//���form��
	        setFormShow(rowData);//��ֵform��
	        rewTbUrl(rowData);//table��дurl
	        requested=1;//�����Ƿ�������
	    },
		onLoadSuccess:function(data){
			// ���ط�ҳͼ��
            $('#List .pagination-page-list').hide();
            $('#List .pagination-info').hide();
		}
	});
	//����ˢ��
    //$('#DisReqpatReqedTb').datagrid('getPager').pagination({ showRefresh: false});   
}
function GetSearchInfo()
{
	var VisDept=$('#VisLoc').combobox('getValue');
	
	var VisDate=$('#VisDate').datebox('getValue');
	var AdmName=$('#AdmName').val();
	if($('#Adm').is(':checked')){
		var PatRegNo=$("#PatNoSearch").val();
	}else{
		
		var PatRegNo=$("#PatNo").val();
	}
	
	var StDate=$("#StDate").datebox("getValue");  	//��ʼ����
	var EndDate=$("#EndDate").datebox("getValue");  //��������
	var Str=VisDept +"^"+ VisDate +"^"+ AdmName +"^"+ PatRegNo +"^"+ StDate +"^"+ EndDate;
	var LocID="";
	if(LocDesc.indexOf("��������") != "-1")
	{
		LocID=VisDept;
	}else if(VisDept!="")
		{ 
			LocID=VisDept; 
		}else{LocID=LgCtLocID}
	
	$('#DisReqPatTb').datagrid({
		queryParams:{SelByAdm:SelByAdm,Str:Str,LocID:LocID}	
	})
}
//  **********************************************
function DisAffirm()
{
	var statuText=$("#AffirmStatusS").combobox("getText")
	if(statuText!="���")
	{
		$.messager.alert("��ʾ","����ݲ�ѯ��������ɡ���ѯ����ɵ����룬��ȷ����ɣ�")
		return;	
	}
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');  /// sufan 2017-12-15 �޸�����ȷ��
	/// sufan 2017-12-15 �޸�����ȷ��
	if(selItems.length==0){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	var mainID=""
	for(i = 0;i < selItems.length; i++)
	{
		if(selItems[i].newStatus!="���")
		{
			$.messager.alert("��ʾ","����δ���״̬�����룬���ܽ������ȷ�ϣ�")
			return;	
		}
		
		var DismainID=selItems[i].mainRowID
		var TypeID=selItems[i].TypeID
		if(mainID=="")
		{
			mainID=DismainID
		}else{
			mainID=mainID +"$"+DismainID
		}
	}
	
	DisAffirmWindow(mainID,TypeID);
}
function DisAffirmWindow(mainID,TypeID)
{
	
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').append('<div id="ptab"></div>');

	$('#win').window({
			iconCls:'icon-blue-edit',
			title:'����',
			border:true,
			closed:"true",
			width:600,
			height:350,
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
	var iframe='<iframe id="ifraemApp" scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.disaffirm.csp?mainRowID='+mainID+'&createUser='+LgUserID+'&type='+TypeID+'"></iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
}
//����ȷ��
function exeDis(){
	if((rowDataS=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
		}
	var mainID = rowDataS.mainRowID
	var TypeID = rowDataS.TypeID
	$.messager.confirm('����ȷ��','ȷ�Ͻ�������״̬��Ϊ���ȷ����',function(r){
		if (r){
			runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainID,"type":TypeID,"statuscode":16,"lgUser":LgUserID,"EmFlag":"Y","reason":""},
					function(data){
						if(data!=0){
							$.messager.alert("��ʾ",data);	
						}
						else{
							$.messager.alert("��ʾ","�����ɹ���");
						}
						
					},'text',false)
			$('#cspAffirmStatusTb').datagrid('reload');
			rowDataS="";
		}		
	})
}

// ��������
function Undorequest(){
	
	var rowData=$("#cspAffirmStatusTb").datagrid('getSelections')
	if((rowData=="")){
			$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
			return;	
	}
	var dataList = [];
	for(var i=0;i<rowData.length;i++)
	{
		if((rowData[i].newStatus!="������")&&(rowData[i].newStatus!="��������")){
			$.messager.alert("��ʾ","��ѡ������״̬�Ǵ������������,���ʵ"); 
			return false;
		}
		var StatusCode=100
		var tmp=rowData[i].mainRowID +"^"+ StatusCode +"^"+ rowData[i].TypeID +"^"+ rowData[i].newStatus +"^"+ LgUserID;
		dataList.push(tmp);
	}
	var params=dataList.join("&&");
	//var ss=ReqID+"^"+StatusCode+"^"+ReqType+"^"+LgUserID
	//alert(ss)
	$.messager.confirm('ȷ��','��ȷ��Ҫ����������¼��',function(r){
			if(r){
				runClassMethod("web.DHCDISAffirmStatus","CancelApplicaion",{'params':params},function(data){
					if(data==0){
						$.messager.alert("��ʾ","�����ɹ���");
					}
					else if(data=="-1")
					{
						$.messager.alert("��ʾ","��ȡ�¸�����״̬ʧ�ܣ�");
					}
					else if(data=="-2")
					{
						$.messager.alert("��ʾ","�������뵥״̬ʧ�ܣ�");
					}
					else if(data=="-3")
					{
						$.messager.alert("��ʾ","���������ˮ��ʧ�ܣ�");
					}else
					{
						$.messager.alert("��ʾ","����ʧ�ܣ�");
					}
				},'text',false)
				$('#cspAffirmStatusTb').datagrid('reload');
			}	
	})
}


//���鵯����ҳ��
function ParticularsPages(){
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	if((selItems=="")||(selItems.length>1)){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}
	
	if($('#detailswin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�detailswin

	$('body').append("<div id='detailswin' class='hisui-window' title='����' style='width:800px;height:400px;top:100px;left:260px;padding:10px'></div>");

	$('#detailswin').window({
		iconCls:'icon-paper-info',
		border:true,
		closed:"true",
		width:800,
		height:400,
		collapsible:true,
		minimizable:false,
		maximizable:false,
		resizable:false,
		//draggable:false,
		onClose:function(){
			$('#detailswin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
			}
	}); 

	//iframe ����
	var iframe='<iframe scrolling="no" width=100% height=98%  frameborder="0" src="dhcdis.affirmdetail.csp?mainRowID='+selItems[0].mainRowID+'&typeID='+selItems[0].TypeID+'"></iframe>';
	$('#detailswin').html(iframe);
	$('#detailswin').window('open');
}
///������������
function RequestCopy()
{
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	if((selItems=="")||(selItems.length>1)){
		$.messager.alert("��ʾ","��ѡ������һ�����뵥��")
		return;	
	}

	$('#copyTimePanel').window({
		iconCls:'icon-copy',
		title:'���ƴ���',
		collapsible:false,
		minimizable:false,
		border:false,
		closed:false,
		width:500,
		height:240
	});
			
	$('#copyTimePanel').window('open');
	InitCopyCombobox();  //��ʼ��combobox
	GetReqMessage(selItems); //��ȡ���뵥��Ϣ
}
///��ʼ��combobox
function InitCopyCombobox()
{
	$('#CopyRecLoc').combobox({ //���տ���    
	    //url:LINK_CSP+"?ClassName=web.DHCDISAffirmStatus&MethodName=GetApplayLoc&HospID="+hosp,
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote'     
	});
	$('#CopyReqType').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#CopyReqWay').combobox({ //���ͷ�ʽ 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#CopyTime').combobox({ //����ʱ�� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	$('#CopyTimePart').combobox({ //����ʱ��� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTimePart",    
	    valueField:'id',    
	    textField:'text',
	    panelHeight:'auto'
	});
	///��ʼ��������Ա������
	$('#EsCopyper').combobox({
		url:LINK_CSP+"?ClassName=web.DHCDISEscortArrage&MethodName=GetSSUser&LocID="+LgCtLocID,
		valueField:'value',
	    textField:'text',
	    mode:'remote'
	});
}
///��ȡ���뵥��Ϣ  2017-06-02  zwq
function GetReqMessage(selItems)
{
	var ReqID=selItems[0].mainRowID;
	runClassMethod("web.DHCDISAffirmStatus","GetReqMessage",{'ReqID':ReqID},function(data){
				SetComboboxValue(data);
			},'text');
	
}
///��combobox����ԭ���뵥Ĭ��ֵ
function SetComboboxValue(ReqMessage)
{
	var CopyReqRecLocdr=ReqMessage.split("^")[0];
	var CopyReqWay=ReqMessage.split("^")[1];
	var CopyReqType=ReqMessage.split("^")[2];
	var CopyReqMark=ReqMessage.split("^")[3];
	if(CopyReqRecLocdr=="")
	{
		$('#CopyRecLoc').combobox({disabled:true});
	}
	else
	{
		$('#CopyRecLoc').combobox('setValue',CopyReqRecLocdr);
	}
	$('#CopyReqWay').combobox('setValue',CopyReqWay);
	$('#CopyReqType').combobox('setValue',CopyReqType);
	$('#CopyNote').val(CopyReqMark);
}
///ȷ�ϸ�����������
function SureRequestCopy(){
	var selItems = $('#cspAffirmStatusTb').datagrid('getSelections');
	var ReqID=selItems[0].mainRowID
	var ReqRecLoc=selItems[0].acceptLoc
	var CopyReqRecLoc=$('#CopyRecLoc').combobox('getValue');//���տ���
	var CopyReqDate=$('#CopyStartDate').combobox('getValue'); //��������
	var CopyReqWay=$('#CopyReqWay').combobox('getValue');
	var ReqWayText=$('#CopyReqWay').combobox('getText');
	var CopyReqTimePoint=$('#CopyTime').combobox('getText');
	var CopyReqTimeValue=$('#CopyTime').combobox('getValue')
	var CopyReqType=$('#CopyReqType').combobox('getValue');
	var ReqTypeText=$('#CopyReqType').combobox('getText');
	//var CopyReqTime=$('#CopyTime').combobox('getText')
	var CopyReqTime=""
	var CopyReqNote=$('#CopyNote').val();
	CopyReqNote = CopyReqNote.replace(/\^/g,'');
	var CopyNum=1
	CopyDate=CopyReqDate+" "+CopyReqTime+" "+CopyReqTimePoint;

	var DateFlag=serverCall("web.DHCDISRequest","JudgeDate",{"Date":CopyReqDate})
	var TimeFlag=serverCall("web.DHCDISRequest","JudgeTime",{"Date":CopyReqDate,"Time":CopyReqTimePoint})
	var ReqTypeText=$('#CopyReqType').combobox('getText');
	var ReqWayText=$('#CopyReqWay').combobox('getText');
	var EsCopyper=$("#EsCopyper").combobox('getValue');
	var EsCopyperText=$("#EsCopyper").combobox('getText');
	if(CopyReqDate=="")
	{
		$.messager.alert("��ʾ:","��ѡ����������!");
		return false;
	}
	if((DateFlag==0)&&(LocDesc.indexOf("��������") ==-1)){
		$.messager.alert("��ʾ:","��������С�ڵ�ǰ����!");
		return false;
	}
	if(CopyReqTimePoint=="")
	{
		$.messager.alert("��ʾ:","��ѡ������ʱ��!");
		return false;
	}
	if(CopyReqTimeValue==undefined)
	{
		$.messager.alert("��ʾ:","����ʱ���ʽ����,��ѡ������ʱ��!");
		return false;
	}
	if((TimeFlag==0)&&(LocDesc.indexOf("��������") =="-1")){
	$.messager.alert("��ʾ:","����ʱ��С�ڵ�ǰʱ��!");
		return false;
	}
	if((CopyReqWay=="")||(ReqWayText==""))
	{
		$.messager.alert("��ʾ:","��ѡ�����ͷ�ʽ!");
		return false;
	}
	if(CopyReqWay==undefined)
	{
		$.messager.alert("��ʾ:","���ͷ�ʽ��������,��ѡ�����ͷ�ʽ!");
		return false;
	}
	if((CopyReqType=="")||(ReqTypeText==""))
	{
		$.messager.alert("��ʾ:","��ѡ����������!");
		return false;
	}
	if(CopyReqType==undefined)
	{
		$.messager.alert("��ʾ:","����������������,��ѡ����������!");
		return false;
	}
	if((ReqRecLoc!="")&&(CopyReqRecLoc==""))
	{
		$.messager.alert("��ʾ:","��ѡ����տ���!");
		return false;
	}
	if(((EsCopyper=="")||(EsCopyperText==""))&&(LocDesc.indexOf("��������") !="-1"))
	{
		$.messager.alert("��ʾ:","��ѡ��������Ա!");
		return false;
	}
	
	var CopyStr=CopyReqRecLoc+"^"+CopyDate+"^"+CopyReqType+"^"+CopyReqWay+"^"+CopyNum+"^"+CopyReqNote+"^"+LgCtLocID+"^"+LgUserID
	runClassMethod("web.DHCDISAffirmStatus","RequestCopy",{'reqID':ReqID,'copyStr':CopyStr},function(data){
				if(data>0){
					$.messager.alert("��ʾ","���Ƴɹ�!");
					
					AutoArrangement(data,EsCopyper);
					$('#copyTimePanel').window('close');
					$('#cspAffirmStatusTb').datagrid('reload')
					
					
				}
				else{
					$.messager.alert("��ʾ","����ʧ��!");
				}
				
			},'text');
			rowDataS=="";
		
}

///sufan 2017-11-29 ���ƴ���ȡ���¼�
function CancleRequestCopy()
{
	$('#copyTimePanel').window('close');
}
///�Զ����ŷ���  sufan 2017-11-28�������Զ����ŵķ���
function AutoArrangement(RepID,EscortPer)
{
	var StatusCode="11";
	runClassMethod("web.DHCDISRequest","AutoArrangement",{'RepID':RepID,'StatusCode':StatusCode,'OperID':UserID,'RepLoc':LgCtLocID,'EscortPerID':EscortPer},function(data){

	},'text',false)
}
///sufan 2018-01-02
function initPatList()
{
	//�����б�
	// ����columns
	var columns=[[
		{field:'PatLabel',title:'Ԥ�����',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'�ǼǺ�',width:100,hidden:true},
		{field:'PatName',title:'����',width:100,hidden:true},
		{field:'PatBed',title:'����',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'�Ա�',width:100,hidden:true},
		{field:'Adm',title:'����ID',width:100,hidden:true},
	]];
	var LocID=$('#VisLoc').combobox("getValue")	///sufan 2018-01-02  ����̨��session��Ϊjs��ֵ
	//var Str=LocID +"^"+ "" +"^"+ "" +"^"+ "";	
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=SelByAdm&SelByAdm="+SelByAdm+"&LocID="+LocID,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    pagination:true,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        PatAdm=rowData.Adm ;   //sufan 2017-12-03
	        clearForm();//���form��
	        setForm(rowData);//��ֵform��
	        rewTbUrl(rowData);//table��дurl
	        selAdmReq(rowData);//���Ҷ�Ӧ�������뵥
	        requested=0;//�����Ƿ�������
	    },
		onLoadSuccess:function(data){
			// ���ط�ҳͼ��
            //$('#List .pagination-page-list').hide();
            var rows = $("#DisReqPatTb").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].Adm==PatAdm)
	            {
		            $('#DisReqPatTb').datagrid('selectRow',i);
		            clearForm();//���form��
	        		setForm(rows[i]);//��ֵform��
	        		rewTbUrl(rows[i]);//table��дurl
	        		selAdmReq(rows[i]);//���Ҷ�Ӧ�������뵥
	        		requested=0;//�����Ƿ�������
				}
	         }
            $('#List .pagination-info').hide();
            
            
		}
	});
	//����ˢ��
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false}); 
	/*//�����б�
	// ����columns
	var columns=[[
		{field:'PatLabel',title:'Ԥ�����',width:174,formatter:setCellLabel},
		{field:'PatNo',title:'�ǼǺ�',width:100,hidden:true},
		{field:'PatName',title:'����',width:100,hidden:true},
		{field:'PatBed',title:'����',width:100,hidden:true},
		{field:'ADMDate',title:'AdmDate',width:100,hidden:true},
		{field:'ADMSex',title:'�Ա�',width:100,hidden:true},
		{field:'Adm',title:'����ID',width:100,hidden:true},
	]];
	var LocID=$('#VisLoc').combobox("getValue");
	var Str=LocID +"^"+ "" +"^"+ "" +"^"+ "";
	$('#DisReqPatTb').datagrid({
		url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=getPatListByLoc&Str="+Str,
		fit:true,
	    border:false,
		rownumbers:true,
		nowrap: true,
		columns:columns,
		autoRowHeight:true,
		pageSize:200,  		// ÿҳ��ʾ�ļ�¼����
		pageList:[200,300],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
	    pagination:true,
		loadMsg: '���ڼ�����Ϣ...',
		showHeader:false,
		rownumbers : true,
		showPageList : true,
        onClickRow:function(rowIndex, rowData){
	        clearForm();			//���form��
	        setForm(rowData);		//��ֵform��
	        rewTbUrl(rowData);		//table��дurl
	        selAdmReq(rowData);		//���Ҷ�Ӧ�������뵥
	        requested=0;			//�����Ƿ�������
	        PatAdm=rowData.Adm;	 	///sufan 2017-12-21  ���߾����
	        //alert(PatAdm)
	    },
		onLoadSuccess:function(data){
			// ���ط�ҳͼ��
            $('#List .pagination-info').hide();
		}
	});
	//����ˢ��
    $('#DisReqPatTb').datagrid('getPager').pagination({ showRefresh: false});*/
	
}
function initPatform()
{
	$('#VisLoc').combobox({ //�������    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote',
    	onSelect:function(option){
	        //GetSearchInfo();
	    }     
	});
	//$('#VisLoc').combobox("setValue","216")
	$('#RecLoc').combobox({ //���տ���    
    	url:LINK_CSP+"?ClassName=web.DHCDISCommonDS&MethodName=LocCombo&HospID="+LgHospID+"&DefLoc="+LgCtLocID,    
    	valueField:'id',    
    	textField:'text',
    	mode:'remote' ,
    	onSelect:function(){
	    	var Othsel=$("#DisReqOthTb").datagrid('getSelections');
	    	var lenOth=$("#DisReqOthTb").datagrid('getSelections').length;
	    	var len=$("#DisReqOrdTb").datagrid('getSelections').length;
	    	if(len==0)
	    	{
				if(lenOth==0)
	    		{
		    		$('#RecLoc').combobox('setValue',"");
		    		$.messager.alert("��ʾ:","����ѡ��������Ŀ!");
		    		return;
		    	}else if(Othsel[0].RecLocFlag!="Y")
		    		{
			    		 $('#RecLoc').combobox('setValue',"");
			    	}
		    }
		    else
		    {
			   $('#RecLoc').combobox('setValue',"");
		    	return; 
			}
	    }
    
	});  
	$('#ReqType').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisTypeList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});  
	$('#ReqWay').combobox({ //���ͷ�ʽ 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisToolList&HospID="+LgHospID,    
	    valueField:'id',    
	    textField:'text'   
	});
	$('#Time').combobox({ //����ʱ�� 
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=IntTime",    
	    valueField:'id',    
	    textField:'text',  
	});
	/*$('#ReqNum').combobox({ //��������   
	    url:LINK_CSP+"?ClassName=web.DHCDISRequest&MethodName=DisNumlList",    
	    valueField:'id',    
	    textField:'text',
	    onSelect: function () {
				//��ȡѡ�е�ֵ
				var varSelect = $(this).combobox('getValue');
				runClassMethod("web.DHCDISRequest","GetNowReqNum",
			    {Loc:varSelect},
				function(data){
					if(data<varSelect){
						$.messager.alert("��ʾ","��ǰ��������Ϊ "+data+" ��!");
					}
				});	
								
		}  
	});*/
}
///����/��ʾ���ֿؼ�
function hideControl()
{	
	if($('#Adm').is(':checked')){
		$("#AdmLoc").hide();   		//�������
		$("#AdmDate").hide();   	//��������
		$("#PatName").hide();   	//��������
		$("#PatRegNo").hide();  	//�ǼǺ�
		$("#SearStDate").show();    //��ʼ����
		$("#SearEndDate").show();   //��������
		$("#SeaPatNo").show();		//�ǼǺ�
		$("#VisLoc").combobox("setValue","");   	//�������
		$("#VisDate").datebox("setValue","");   	//��������
		$("#AdmName").val("");   	//��������
		$("#PatNo").val("");  	//�ǼǺ�
		$("#VisLoc").combobox("hidePanel");
		$("#VisDate").datebox("hidePanel");
		
	}else{
		$("#AdmLoc").show();   		//�������
		$("#AdmDate").show();   	//��������
		$("#PatName").show();   	//��������
		$("#PatRegNo").show();  	//�ǼǺ�
		$("#SearStDate").hide();    //��ʼ����
		$("#SearEndDate").hide();   //��������
		$("#SeaPatNo").hide();		//�ǼǺ�
		$("#PatNoSearch").val("");
		$("#StDate").datebox("hidePanel");
		$("#EndDate").datebox("hidePanel");
		$("#StDate").datebox("setValue",formatDate(0));	 	 ///��ʼ����
		$("#EndDate").datebox("setValue",formatDate(0));	 ///��������
		
	}
	$("#StDate").datebox("setValue",formatDate(0));	 	 ///��ʼ����
	$("#EndDate").datebox("setValue",formatDate(0));	 ///��������
}