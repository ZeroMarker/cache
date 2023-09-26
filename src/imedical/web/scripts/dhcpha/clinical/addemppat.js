/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:�����б�
*/
var frm = dhcsys_getmenuform()
frm.EpisodeID.value=""
var url='dhcpha.clinical.action.csp' ;
var drugSearchLocID=""; //dws 2017-11-16 �����ٴ�ҩѧ��ҳ���ߺ󽫲���ID����ҩ��ҳ��
function BodyLoadHandler()
{
   
	$('#patgrid').datagrid({  
			  bordr:false,
			  //fit:true,
			  //fitColumns:true,
			  singleSelect:true,
			  idField:'patadm', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//�к�
			  pageSize:30,
			  pageList:[30,60],
			  columns:[[ 
			  {field:'WardID',title:'WardID',width:100,hidden:true},
			  {field:'patward',title:'����',width:160},
			  {field:'monLevel',title:'�໤����ID',width:80,align:'center',hidden:true},
			  {field:'monLevelDesc',title:'�໤����',width:80,align:'center',
			  		formatter:setMonLevelDescShow
			  },
			  {field:'patbed',title:'����',width:80},
			  {field:'monCount',title:'�໤����',width:60,formatter:setCellLink,align:'center'},
			  {field:'patno',title:'�ǼǺ�',width:100,formatter:fomartShowPatInfo}, 
			  {field:'patname',title:'����',width:100},   
			  {field:'patsex',title:'�Ա�',width:70},
			  {field:'patage',title:'����',width:70},
			  {field:'patheight',title:'���',width:60},
			  {field:'patweight',title:'����',width:60},
			  {field:'patindate',title:'��Ժ����',width:100},
			  {field:'patloc',title:'����',width:150},
			  {field:'AdmLocID',title:'AdmLocID',width:150,hidden:true},
			  {field:'patroom',title:'����',width:100},
			  {field:'patdoctor',title:'����ҽʦ',width:80},
			  {field:'patempflag',title:'�ص��ע',width:80,hidden:true,
			  		formatter:SetCellColor},
			  {field:'patdiag',title:'���',width:400},
			  {field:'patadm',title:'adm'},
			  {field:'monSubCId',title:'ѧ�Ʒ���',hidden:true},
			  {field:'PatientID',title:'PatientID'}

			  ]],
			  url:url,
			  queryParams: {
					action:'QueryInHosPatList',
					input:""+"^"+session['LOGON.CTLOCID']
			  },
			  toolbar:"#gridtoolbar",
			  onClickRow:function(rowIndex, rowData){ 

                 var patward=rowData.patward;
				 $("#labpatward").text(patward);
				 var patbed=rowData.patbed;
				 $("#labpatbed").text(patbed);
				 var patno=rowData.patno;
				 $("#labpatno").text(patno);
				 var patname=rowData.patname;
				 $("#labpatname").text(patname);
                 var patsex=rowData.patsex;
				 $("#labpatsex").text(patsex);
                 var patage=rowData.patage;
				 $("#labpatage").text(patage);
                 var patheight=rowData.patheight;
				 $("#labpatheight").text(patheight);
				 var patweight=rowData.patweight;
                 $("#labpatweight").text(patweight);
				 var patdoctor=rowData.patdoctor;
				 $("#labpatdoctor").text(patdoctor);
				 var patdiag=rowData.patdiag;
				 if(patdiag.length>40){
					 patdiag=patdiag.substring(0,40)+"......";  //��ȡǰ40���ַ�
					 }
				 $("#labpatdiag").text(patdiag);
                 var patindate=rowData.patindate;
				 $("#labpatindate").text(patindate);
				 var frm=window.parent.parent.document.forms["fEPRMENU"];	//lbb  2018-09-13
				 if(frm.EpisodeID){
					frm.EpisodeID.value=rowData.patadm;
					frm.PatientID.value=rowData.PatientID;
				 }
			  },
			  onDblClickRow:function(rowIndex, rowData){
			  	  showPatPhaSerWin();
			  }	
		  });

         //�������߲鷿�б�
        $('#btnExport').on('click',BtnExportHandler)

		//�����ע
		$("#btnAddEmp").click(function (e) { 

                var row=$('#patgrid').datagrid('getSelected');
                if (row)
				{
					var adm=row.patadm;
					//AddEmpFlag(adm,'Y');
					SignEmpPat(adm);
				}
				else{
					$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
					return;
				}
                //var rowIndex=$('#patgrid').datagrid('getRowIndex',$('#patgrid').datagrid('getSelected')) 
                

         })


��������//ȡ����ע
		$("#btnCancelEmp").click(function (e) { 

                var row=$('#patgrid').datagrid('getSelected');
				if (row)
				{
					var adm=row.patadm ;
					AddEmpFlag(adm,'N');
				}
				else{
					$.messager.alert('������ʾ','����ѡ��һ�м�¼!',"error");
					return;
				}

         })

        //ˢ��
		$("#btnReload").click(function (e) { 
����������������ReLoad();

        })

		//��ѡ�ص��ע
		$("#chkempflag").click(function (e) { 
����������������ReLoad();

         })


			 
		//��ѯ��¼
		/*
		$("#btnWRRec").click(function (e) {
			
			    var data="";

				var row=$('#patgrid').datagrid('getSelected');
				if (row)
				{
					var patward=row.patward;
					var patbed=row.patbed;
					var patname=row.patname;
					var adm=row.patadm ;
					
				}
                data=patward+"^"+patbed+"^"+patname+"^"+adm ;
����������������OpenRoomlogWin(data);

         })
         */
        //ҩ����д
		$("#btnWDRec").bind('click',function(e){
            var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm;  		  //����ADM
				var PatientID=row.PatientID;  //����PatientID
				showMedRecordWin(AdmDr,PatientID,drugSearchLocID);
			}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
         }) 
        
        //��ҩ����
		$("#btnWUseRec").bind('click',function (e) { 
            var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				showMedSuggestWin(AdmDr); 
			}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
         })
         
        //������Ӧ����
		$("#btnAdrRep").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"ADR",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		//��ҩ����
		$("#btnDrgMis").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"DRGMIS",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		 //ҩƷ����
		$("#btnDrgQua").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"DRGQUA",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		 //ҩѧ�鷿
		$("#btnPhaWard").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"PHAWARD",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		 //ҽѧ�鷿
		$("#btnMedWard").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"MEDWARD",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		 //��ҩ����
		$("#btnMedEducation").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"MEDEDU",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		 //ҩѧ�໤
		$("#btnDrgMontor").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //����ADM
				var PatientID=row.PatientID  //����PatientID
        		showAdrRepWin($(this).text(),"DRGMON",AdmDr,PatientID);
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
				
		 //ҩѧ�໤New
		$("#btn_monitor").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var monAdmDr=row.patadm;   //����ADM
				var monLevID=row.monLevel; //�໤����
				var monLocID=row.AdmLocID; //����
				var monSubCId=row.monSubCId; //ѧ�Ʒ���
				var monWardID=row.WardID; //����
				var monLevelDesc=row.monLevelDesc; //�໤��������
				var LocDesc= tkMakeServerCall("web.DHCSTPHCMEMPPAT","GetLocNameByLocID",session['LOGON.CTLOCID']);
				showEditWin(monLocID,monLevID,monAdmDr,monSubCId,monWardID,monLevelDesc);       		
        	}else{
				$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
			}
		})
		
		InitPageQueryDiv(); //��ʼ��ҳ���ѯDiv
}



function showPatInfo(adm,patno)
{
	createPatInfoWin(adm,patno);
}

function  fomartShowPatInfo(value,rowData,rowIndex){ 

        return "<a href='#' mce_href='#' onclick='showPatInfo("+rowData.patadm+","+rowData.PatientID+");'>"+rowData.patno+"</a>";  

 
}

function  setCellLink(value,rowData,rowIndex){ 
	//��adm�ͼ໤���𴫵ݣ������˵���໤��������ȥ��û��ѡ���е�����  qunianepng 2016/11/22
    return "<a href='#' mce_href='#' onclick=\"showPatMonWin('"+rowData.patadm+"','"+rowData.monSubCId+"','"+rowData.monLevelDesc+"')\">"+value+"</a>";  
}
//�������
function AddEmpFlag(adm,flag)
{
	        var user=session['LOGON.USERID'] ;
			var input=user+"^"+adm+"^"+flag+"^"+"EMP";
			var data = jQuery.param({ "action":"AddEmpFlag","input":input});

			var request = $.ajax({
				url: url,
				type: "POST",
				async: true,
				data: data,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
                     if (r)
                     {
						 ret=r.retvalue; 
                         
						 if (ret=="0")
						 {
							if (flag=="Y")
							{
								$.messager.alert('������ʾ','�ѹ�ע!',"info");
							}else{
								$.messager.alert('������ʾ','��ȡ����ע!',"info");
							}
                            ReLoad();
						 }

						 if (ret=="-99")
						 {
							 $.messager.alert('������ʾ','֮ǰδ��ע,����ȡ��!',"error");
						 }
                     }
					
		                    
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}

			    });


}
					  
//ˢ��
function ReLoad()
{
	var empflag="N";
	if ($('#chkempflag').attr('checked')) //�ص��ע
	{
		var empflag="Y" ;
	}
	var input=empflag;

	$('#patgrid').datagrid('load',  {  
				action: 'QueryInHosPatList',
				input:empflag
	});
}

//�ǼǺ��������� formatter="SetCellColor"  bianshuai 2014-09-22
function SetCellColor(value, rowData, rowIndex)
{
	var html="";
	if(value=="Y"){
		html='<span style="color:red;font-weight:600">�ѹ�ע</span>';
	}
	return html;
}

/// ������ҩ���鴰��
function showMedSuggestWin(AdmDr)
{
	createMedAdviseWin(AdmDr);
}

/// ����ҩ����д����
function showMedRecordWin(AdmDr,PatientID,drugSearchLocID)
{
	createMedRecordWin(AdmDr,PatientID,drugSearchLocID);
}

//�༭����
function showAdrRepWin(Title,RepType,AdmDr,PatientID)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:Title,
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		minimizable:false,					/// ������С����ť
		maximized:true,						/// ���(qunianpeng 2018/3/10)		
		onClose:function(){
			$('#win').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});
	var advcode="";
    switch(RepType){
	    case "ADR":
			//maintab="dhcpha.clinical.adrreport.csp";  			/// ������Ӧ
			//maintab="dhcadv.advreport.csp";  						/// ������Ӧ
			maintab="dhcadv.layoutform.csp"          /// ������Ӧ
			advcode="advDrug";
			break;
		case "DRGQUA":
			//maintab="dhcpha.clinical.drugqualityevtreport.csp";		/// ҩƷ����
			maintab="dhcadv.layoutform.csp";                              /// ҩƷ����
			advcode="advDrugquality";
			break;
		case "DRGMIS":
			//maintab="dhcpha.clinical.drugmisusereport.csp";	    /// ��ҩ����
			maintab="dhcadv.medsafetyreport.csp";                   /// ��ҩ����
			break; 
		case "PHAWARD":
			maintab="dhcpha.clinical.phawardround.csp";				/// ҩѧ�鷿
			break;
		case "MEDWARD":
			maintab="dhcpha.clinical.medwardround.csp";				/// ҽѧ�鷿
			break;
		case "MEDEDU":
			maintab="dhcpha.clinical.mededucation.csp";				/// ��ҩ����
			break;
		case "DRGMON":
			maintab="dhcpha.clinical.drugmontor.csp";				/// ҩѧ�໤
			break;
    }

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+PatientID+'&EpisodeID='+AdmDr+'&frmflag='+1+'&code='+advcode+'&quoteflag='+1+'"> </iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	/*
	window.open('dhcpha.clinical.adrreport.csp?PatientID='+22+'&EpisodeID='+1+'','','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=570,left=80,top=40');
	*/
}

///��ע�ص㻼�� 2015-1-6 bianshuai
function SignEmpPat(admDr)
{
	$('#empatwin').css("display","block");
	$('#empatwin').dialog({
		title:"��ǻ��߼໤����",
		collapsible:false,
		border:false,
		closed:"true",
		width:300,
		height:460,
		buttons:[{
				text:'����',
				iconCls:'icon-save',
				handler:function(){
					saveEmPat(admDr);
					$('#patgrid').datagrid('reload');  //qunianpeng 2016-08-04
					}
			},{
				text:'�ر�',
				iconCls:'icon-cancel',
				handler:function(){
					$('#empatwin').dialog('close');
					$("#empatwin").css("display","none");
					}
			}]
	});
	$("#stdate").datebox("setValue", formatDate(0));
	$("#sttime").timespinner('setValue', formatCurrTime());
	$("#enddate").datebox("setValue", "");
	$("#endtime").timespinner('setValue', "");
	$("#user").combobox('setValue',"");
	$("#remark").val("");
	$("#reason").val("");
	$("#empPatID").val("");
	var panelHeightOption = {panelHeight : "auto"};
	/* ���ü�ؼ��� */
	var monLevCombobox = new ListCombobox("monlevel",url+'?action=SelMonLevel','',panelHeightOption);
	monLevCombobox.init();
	/* ת������ */
	var trmLevCombobox = new ListCombobox("trmlevel",url+'?action=SelMonLevel','',panelHeightOption);
	trmLevCombobox.init();
	$('#trmlevel').combobox({
		disabled:true
	});
	
	//�û�
	$("#user").combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		onShowPanel:function(){
			$('#user').combobox('reload',url+'?action=SelUserByGrp&grpId='+session['LOGON.GROUPID'])
		}
	});
	
	var row=$('#patgrid').datagrid('getSelected');
	if(row.monLevel==""){
		$('#user').combobox({disabled:true});
		$("#user").combobox('setValue',session['LOGON.USERID']);
		$("#user").combobox('setText',session['LOGON.USERNAME']);
		$("#monlevel").combobox({disabled:false});  //qunianpeng 2016-08-04
		$("#enddate").datebox({disabled:true});     //qunianpeng 2016-08-17
		$("#endtime").timespinner({disabled:true});
	}else{
		getEmPatInfo(admDr);   //�����ص㻼����Ϣ
	}
	$('#empatwin').dialog('open');
}

//�����ص㻼��
function saveEmPat(EpisodeID)
{
	var stdate = $('#stdate').combobox('getValue');      //��ʼ����
	var sttime = $('#sttime').timespinner('getValue');   //��ʼʱ��
	var user = $("#user").combobox('getValue');  		 //����ҩʦ
	var monlevel = $("#monlevel").combobox('getValue');  //��ؼ���
	var trmlevel = $("#trmlevel").combobox('getValue');  //תΪ����
	var enddate = $('#enddate').combobox('getValue');    //��������
	var endtime = $('#endtime').timespinner('getValue'); //����ʱ��
	var reason=$('#reason').val(); //ԭ��
	var remark=$('#remark').val(); //��ע
	
	var empPatID = $('#empPatID').val(); //�ص㻼�߼�¼ID
	if (empPatID==""){
		
		if((stdate=="")||(sttime=="")){
			$.messager.alert('������ʾ','��ʼ���ڻ�ʱ�䲻��Ϊ��!',"info");
			return;
		}

		if(monlevel==""){
			$.messager.alert('������ʾ','��ؼ�����Ϊ��!',"info");
			return;
		}
	}
	else{

		if((enddate=="")||(endtime=="")){
			$.messager.alert('������ʾ','�������ڻ�ʱ�䲻��Ϊ��!',"info");
			return;
		}
		if(ChangeTimeStamp(stdate,sttime)>ChangeTimeStamp(enddate,endtime)){	 /// �޸����ڱȽ� qunianpeng 2018/3/21		 
		     $.messager.alert('������ʾ','�������ڻ�ʱ�䲻��С�ڿ�ʼ���ڻ�ʱ��!',"info");
		     return;
		} 
		monlevel="";
	}
	
	//�໤�����б�
	var empdatalist = stdate+"^"+sttime+"^"+EpisodeID+"^"+monlevel+"^"+user+"^"+remark+"^"+enddate+"^"+endtime+"^"+reason;
	//����
    var saveflag = saveEmPatAjax(empPatID,empdatalist,monlevel);
    
    ///�л��໤����
    if (trmlevel != ""){
	    monlevel = trmlevel;
	    var empdatalist = enddate+"^"+endtime+"^"+EpisodeID+"^"+trmlevel+"^"+user+"^"+remark+"^^^"+reason;
		saveflag = saveEmPatAjax("",empdatalist);
	}

	if (saveflag){
		var row=$('#patgrid').datagrid('getSelected');
		var index = $("#patgrid").datagrid('getRowIndex', row);   //��ȡѡ���е�����
		$('#patgrid').datagrid('updateRow',{index: index,row:{monlevel:monlevel}});
		/// �رմ���
		$('#empatwin').dialog('close');  
	}
}

///����
function saveEmPatAjax(empPatID,empDataList){
	/// ����Ajax����
    $.ajax({type: "POST", url: url, data: "action=saveEmpPat&empPatID="+empPatID+"&empPatList="+empDataList,dataType: "json",
       success: function(val){
	      if (val=="0") {
		     return true;
	      }else{
		  	 $.messager.alert("��ʾ:",val,"error");
		  	 return false;
		  }
       },
       error: function(){
	       $.messager.alert("��ʾ:","���ӳ���","error");
	       return false;
	   }
    });	
    return true;
}

// ��ȡ�ص㻼�߼໤��Ϣ
function getEmPatInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
   $.ajax({
	   type: "POST",
	   url: url,
	   data: "action=getEmpPatInfo&AdmDr="+EpisodeID,
	   //dataType: "json",
	   success: function(val){
	
			var tmp=val.split("^");
			//������Ϣ
			$('#empPatID').val(tmp[0]); //�ص㻼�߼�¼ID
			$("#stdate").datebox("setValue", tmp[1]);   	  //��ʼ����
			$("#sttime").timespinner('setValue', tmp[2]);     //��ʼʱ��
			$("#monlevel").combobox('setValue',tmp[3]);       //�໤����
			$('#trmlevel').combobox({disabled:false});
			$('#user').combobox({disabled:true});
			$("#user").combobox('setValue',tmp[4]);    //����ҩʦ
			$("#user").combobox('setText',tmp[5]);     //����ҩʦ
				if(($("#remark").val()!="")&&($("#reason").val()!="")){   //liyarong 2016-09-12
				$("#remark").val("");
				$("#reason").val("");
				}
			$("#remark").val(tmp[6]);  //��ע
			$("#reason").val(tmp[7]);  //ԭ��  
			if(tmp[3]!=""){								//qunianpeng  2016-08-04
				$("#monlevel").combobox({disabled:true});
				$("#monlevel").combobox('setValue',tmp[3]);
				$("#enddate").datebox({disabled:false});     //qunianpeng 2016-08-17
				$("#endtime").timespinner({disabled:false});
			}
	   }
	})
}

// ��ʽ���໤����������ɫ
function setMonLevelDescShow(value,rowData,rowIndex){
	if(value == "") {return;}
	return '<span style="color:'+ value.split("@")[1] +';font-weight:bold;">'+ value.split("@")[0] +'</span>';
}

/// ��ʼ��������ѯ��Ϣ
function InitPageQueryDiv()
{
	//����
/* 	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	}); */
	
	$('#ward').combobox({ //qunianpeng 2017/8/14 ֧��ƴ����ͺ���
		mode:'remote',
		onShowPanel:function(){ 
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+session['LOGON.HOSPID']+'  ')
		}
	});
	$("#tip").css({
		top : ($("#tip").offset().top + 30) + 'px',   
		left : ($("#tip").offset().left - 30)+ 'px'
    })
	$("#tip").animate({opacity: 0}, 800).hide();
	
	//��ѯ��������
	$("a:contains('��ѯ')").bind('click',function(){
		
		$("#tip").css({
			top : ($(this).offset().top + 30) + 'px',   
			left : ($(this).offset().left - 30)+ 'px'
        })
		$("#tip").animate({opacity: 1}, 800).show()
	})
	
	//�ύ
	$("a:contains('�ύ')").bind('click',function(){
		LoadPatList();
	})
	
	//ȡ��
	$("a:contains('�ر�')").bind('click',function(){
		$('#ward').combobox("setValue","");
		$('#patno').val("");
		$("#tip").animate({opacity: 0}, 800).hide();
	})
	
	//����
	$("a:contains('����')").bind('click',function(){
		LoadPatListBack();
	})
	//�ǼǺŰ󶨻س��¼�
    $('#patno').bind('keypress',function(event){
        if(event.keyCode == "13"){
			LoadPatList();
        }
    });
}

/// ���¼��ػ����б�
function LoadPatList()
{
	var WardID=$('#ward').combobox('getValue'); // ����ID
	var PatNo=$.trim($("#patno").val());        // �ǼǺ�
	drugSearchLocID=WardID;
	if(PatNo==""&WardID==""){
		 $.messager.alert("��ʾ:","�ǼǺ�Ϊ�ջ��߲���Ϊ�գ����������룡");
	       return;
	}
	if(PatNo!=""){
		//�ǼǺŲ�0
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen = PatNo.length;
		if (plen>patLen){
		   $.messager.alert("��ʾ:","�ǼǺ�¼�����");
	       return;
		}
		for (i=1;i<=patLen-plen;i++){
		    PatNo="0"+PatNo;  
	    }
	       var patFlag=tkMakeServerCall("web.DHCSTPHCMCOMMON", "checkpatFlag",PatNo,session['LOGON.HOSPID'])
			if(patFlag==1){
			    $.messager.alert("��ʾ:","�û��߲��Ǳ�Ժ���Ļ���");
			       return;
			}
			else if(patFlag==2){
			    $.messager.alert("��ʾ:","�û����ڱ�Ժ��û��סԺ��¼");
			       return;
			}
	}
	$("#patno").val(PatNo);
	$('#patgrid').datagrid('load',{  
		action: 'QueryInHosPatList',
		input:""+"^^"+WardID+"^"+PatNo
	});
}

/// ���¼��ػ����б�
function LoadPatListBack()
{
	var LocID=session['LOGON.CTLOCID']; //��¼����ID
	$('#patgrid').datagrid('load',{
		action: 'QueryInHosPatList',
		input:""+"^"+LocID+"^"+""
	});
}

/// ҩѧ�໤
function showEditWin(monLocID, monLevID, monAdmID, monSubCId, monWardID,monLevelDesc){
	monLevelDesc=escape(monLevelDesc)
	if(monLevID == ""){
		$.messager.alert('��ʾ','<font style="color:red;font-weight:bold;font-size:15px;">���ע�໤��������ԣ�</font>','warning');
		return;
	}
	if($('#monwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"ҩѧ�໤",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		minimizable:false,						/// ������С����ť
		maximized:true,							/// ���(qunianpeng 2018/3/10)		
		onClose:function(){
			$('#monwin').remove();  			/// ���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcaredit.csp?monLocID='+monLocID+'&monLevID='+monLevID+'&monAdmID='+monAdmID+'&monSubCId='+monSubCId+'&monWardID='+monWardID+'&monLevelDesc='+monLevelDesc+' "></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}
//�������Ӵ���ˢ�����ݱ��  qunianpeng 2016-08-08
function loadParWin(){
	$('#monwin').window('close');
	$('#patgrid').datagrid('reload');
}

/// ���˼໤����
function showPatMonWin(monAdmID,monSubClassId,monLevelDesc){
	monLevelDesc=escape(monLevelDesc)
	if (!monAdmID){
		$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
		return ;
	}  //��adm�ͼ໤���𴫵ݽ�����ȥ�����»�ȡѡ���У������˵���໤��������ȴ��û��ѡ���е�����  qunianepng 2016/11/22
	if($('#monwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"�໤��Ϣ��ѯ",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,		
		minimizable:false,					/// ������С����ť
		maximized:true,						/// ���(qunianpeng 2018/3/17)
		onClose:function(){
			$('#monwin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcarequery.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'&monLevelDesc='+monLevelDesc+' "></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}


/// ����ҩѧ���񴰿�
function showPatPhaSerWin(){
	var monAdmID = "";
	var monSubClassId = "";
	var EpisodeID = "";
	var rowData=$('#patgrid').datagrid('getSelected');
	if (rowData){
		monAdmID = rowData.patadm;
		monSubClassId = rowData.monSubCId;
		EpisodeID = rowData.patadm;
	}else{
		$.messager.alert('������ʾ','����ѡ��һ�м�¼,лл!',"error");
	}
	
	if($('#monwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"ҩѧ�����ѯ",
		collapsible:true,
		border:false,
		minimizable:false,
		closed:"true",
		width: $(window).width()*0.9,
		height: $(window).height()*0.9,
		onClose:function(){
			$('#monwin').remove();  //���ڹر�ʱ�Ƴ�win��DIV��ǩ
		}
	});
	var src = 'dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID;
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+ src +'"></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
	
	//window.open('dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID+'', 'newwindow', 'height=500, width=1300, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no');
}

/// ������ת��ʱ��� ����ʱ���С�Ƚ� qunianpeng 2018/3/21
function ChangeTimeStamp(date,time){

	/// �������������ڸ�ʽ ��/��/��   ��-��=��  ��Ҫ�Ƚ�/��ʽת��Ϊ��/��/��
	if (date.indexOf("/")>0){
		var dateArray = date.split("/"); 
		date = dateArray[2]+"/"+dateArray[1]+"/"+dateArray[0];
	}
	var datetime = date +" "+ time;
	var timestamp = Date.parse(new Date(datetime.replace(/-/g, '/')));  
	timestamp = timestamp / 1000;  
	return timestamp;
}
//����
function BtnExportHandler(){
	var p_URL='dhccpmrunqianreport.csp?reportName=DHCST_PHCM_InHosPatInfo.raq';
	window.open(p_URL,"","top=20,left=20,width=930,height=660,scrollbars=1"); 
      
}