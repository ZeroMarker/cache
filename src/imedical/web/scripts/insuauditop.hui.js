/**
 * ����ҽ��ҽ�����JS
 * FileName:insuauditop.hui.js
 * DingSH 2020-03-04
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
var HospDr=session['LOGON.HOSPID'];
var GUser=session['LOGON.USERID'];
var GUserName=session['LOGON.USERNAME'];
var SelPatName="";
var SelBillDr="" ;
var SelOeOrdDr="" ;
var DiagCode="";
var DiagDesc="" 
$(function()
{
 $(document).keydown( 
   function (e){
       //banBackSpace(e);
    });
 //#1��ʼ������˻���gd
 InitPatDg()
    
 //#2��ʼ�������ҽ����Ŀgd
 InitPatOrdDg()

 //#3��ʼ��Btn�¼�
 InitBtnClick();   
 
 //#4 ��ʼ��������Ϣ
 InitDiagDesc();
 
 //#5 ����Ĭ������
 setDefDateValue();
 $("#BtnResume").linkbutton('disable');	
 $HUI.checkbox("#CheckAuditType",{
	onCheckChange:function(e,value){
		if(value) {
			$("#BtnResume").linkbutton('enable');	
			$("#BtnAudit").linkbutton('disable');	
			QryOPChkPatInfo();
		}else{
			$("#BtnResume").linkbutton('disable');	
			$("#BtnAudit").linkbutton('enable');	
			QryOPChkPatInfo();
		}
	}	 
 })
});

/**
* ����Ĭ������
*/
function setDefDateValue() {
	var curDateTime =$.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
	var myAry = curDateTime.split(/\s+/);
	setValueById("stDate", myAry[0]); 
	setValueById("edDate", myAry[0]);
}

//��ʼ��Btn�¼�
function InitBtnClick(){
   //�ǼǺŻس�
   $("#regNo").keydown( function(e){ 
      RegNo_onkeydown(e);
   }); 
   //�����Żس�
   $("#medicareNo").keydown( function(e){ 
      MedicareNo_onkeydown(e);
   }); 
    //���˱�Żس�
   $("#InsuNo").keydown( function(e){ 
      InsuNo_onkeydown(e);
   }); 
   
  //ҽ�����     
   $HUI.linkbutton('#BtnAudit',{
      onClick: function()
           {
              Audit_click();
            }
       });
   //ҽ���ܾ�   
   $HUI.linkbutton('#BtnRefuse',{
           onClick: function()
           {
             Refuse_click();
            }
       });

   //����ҽ�����  
   $HUI.linkbutton('#BtnResume',{
           onClick: function()
           {
              Resume_click();
           }
       });    
       
    //ҽ��������Ϣ     
   $HUI.linkbutton('#btnInsuNotice',
    {
       onClick: function()
            {
              InsuNotice_click();
            }
     });      
 
   //�걨�ϱ�     
   $HUI.linkbutton('#Report ',
    {
       onClick: function()
            {
              Report_click();
            }
     });    
       
  //��������
   $HUI.combobox("#RType",{
      onSelect: function(rec)
      {
	     QryOPChkPatInfo() ;  
	   }
   });
   
    //��Ǯ
   $HUI.combobox("#Price800",{
      onSelect: function(rec)
      {
	     QryOPChkPatInfo() ;  
	   }
   });
  
   }

//��ʼ����������Ϣgd
function InitPatDg()
{
   //��ʼ��datagrid
   $HUI.datagrid("#chkoppatdg",{
	   fit: true,
       //url:$URL,
       selectOnCheck:true,
	   checkOnSelect:true,
       border:false,
       data: [],
        frozenColumns:
       [[ 
          {field:'ordck',title:'ck',width:30,checkbox:true}
         
          ]],
       columns:[[
           {field:'TabRegNo',title:'�ǼǺ�',width:140},
           {field:'TabPatName',title:'����',width:100},
           {field:'TabCTDesc',title:'��������',width:150},
           {field:'TabPatType',title:'��������',width:100},
           {field:'TabDiagDesc',title:'��������',width:140,showTip:true},
           {field:'TabPrescNo',title:'������',width:60},
           {field:'TabOEORIDate',title:'��ҽ������',width:160},
           {field:'TabOEORITimeOrd',title:'��ҽ��ʱ��',width:120},
           {field:'TabOEORIDoctorDesc',title:'��ҽ��ҽ��',width:120},
           {field:'TabAuditFlag',title:'��˱��',width:90},
           {field:'Select',title:'ѡ��',width:60,hidden:true},
               {field:'TabPrescPrice',title:'����',width:90,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(4);
                }
           },
            {field:'TabPackUOM',title:'��λ',width:60},
            {field:'TabOEORIPhQty',title:'����',width:60,align:'right'},
            {field:'TabTotalAmount',title:'���',width:60,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(2);
                }
            },
             {field:'TabArcimDesc',title:'ҽ������',width:180},
            {field:'TabPhcfrCode',title:'Ƶ��',width:60},
            {field:'TabDoseQtyUnit',title:'����',width:60},
            {field:'TabPhOrdQtyUnit',title:'����',width:60},
            {field:'TabPackNum',title:'��������',width:90,hidden:true},
            {field:'TabOEORIRowId',title:'TabOEORIRowId',width:60},
           {field:'TabAuditUserName',title:'�����',width:80},
           {field:'TabAuditDate',title:'�������',width:90},
           {field:'TabAuditTime',title:'���ʱ��',width:80},
           {field:'TabPatNo',title:'ҽ����',width:60},
           {field:'TabPatID',title:'���֤��',width:80},
           {field:'job',title:'���̺�',width:60},
           {field:'TblRType',title:'��������',width:60},
           {field:'TabAdmRowid',title:'TabAdmRowid',width:40,hidden:true},
            {field:'TabDemo',title:'��ע ',width:100,
            editor:{
                       type:'text',
                   }}
           
       ]],
       pageSize: 10,
       pagination:true,
       //onClickRow : function(rowIndex, rowData) {
	       
	    onSelect:function(rowIndex, rowData){
		    setEprMenuForm(rowData.TabAdmRowid); // + DingSH 20220126 
            SelOeOrdDr=rowData.TabOEORIRowId;
            SelPatName=rowData.TabPatName
            QryPatOrd();
           
	       if(rowData.TabAuditFlag=="")
           {
	           
	           disableById('btnSave')
	           disableById('btnAudit')
	           enableById('btnAuditSt')
	       }
	       if(rowData.TabAuditFlag=="���")
           {
	           
	           disableById('btnSave')
	           disableById('btnAuditSt')
	           disableById('btnAudit')
	           QryPatOrd();
	       }
	        
	       
       },
      onUnselect:function(rowIndex, rowData){
	      SelOeOrdDr="";
          SelPatName="";
	       QryPatOrd();
	      },
       onLoadSuccess:function(data)
       {
           //alert(256)
           SelPatRowObj=null;
           SelPatName=""
           QryPatOrd()
       }
   });
   
}

//��ʼ������˻���ҽ��gd
function InitPatOrdDg()
{
    //��ʼ��datagrid
   $HUI.datagrid("#chkoppatorddg",{
	   fit: true,
       //url:$URL,
       width: '100%',
       singleSelect:false,
       rownumbers:true,
       selectOnCheck:true,
	   checkOnSelect:false,
       border:false,
       pageSize: 9999,
       pageList: [9999],
       pagination:true,
       data: [],
       frozenColumns:
       [[
          {field:'ck',title:'ck',width:30,checkbox:true}
         
          ]],
       columns:[[
           {field:'TariDr',title:'�շ���Ŀָ��',width:140},
           {field:'TOEORI',title:'TOEORI',width:10,hidden:true},
           {field:'Tchangeflag',title:'Tchangeflag',width:10,hidden:true},
           {field:'TariCode',title:'�շ���Ŀ����',width:200},
           {field:'TariDesc',title:'�շ���Ŀ����',width:240 },
           {field:'InsuCode',title:'ҽ����Ŀ����',width:220},
           {field:'InsuDesc',title:'ҽ����Ŀ����',width:260 },
           {field:'xmlbDesc',title:'��Ŀ���',width:80},
           {field:'xmlb',title:'��Ŀ���',width:10,hidden:true},
           {field:'Price',title:'����',width:100,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(4);
                }
           },
           {field:'uomDesc',title:'��λ',width:60},
           {field:'sl',title:'����',width:100,align:'right'},
           {field:'Amount',title:'���',width:120,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(2);
                }
           }
       ]],
       onClickRow : function(rowIndex, rowData) {
          
       },
       onLoadSuccess:function(data)
       {
          
       }
   });
}
//��ʼ��������Ϣ
function InitDiagDesc()
{
	$HUI.combogrid('#DiagDesc',{
		 url:$URL,
		 delay: 300,
		 mode: 'remote',
		 method: 'GET',
		 panelWidth:360,
		 idField:'code',
		 textField:'desc',
		 columns:[[
		 {field:'desc',title:'����',width:200},
		 {field:'code',title:'����',width:150}
		 ]],
		 onBeforeLoad:function(param){
			param.ClassName="web.DHCMRDiagnos" ;
	    	param.QueryName="LookUpWithAlias" ;
	    	param.desc = param.q ;
		    param.loc = "" ;
		    param.ver1="" ;
		    param.EpisodeID="" ;
		    param.ICDType="" ;
		    
		},
		onSelect:function(index,row){
			DiagCode=row.code;
			DiagDesc=row.desc;
			}
		 
		});
}


//��ѯ��˻�����Ϣ
function QryOPChkPatInfo()
{
   SelAdmDr="",SelBillDr=""
   var stDate=getValueById('stDate')
   var edDate=getValueById('edDate')
   var CheckAuditType=getValueById('CheckAuditType')
   if(CheckAuditType){CheckAuditType="on" ;}
   else{CheckAuditType="" ;}
   var RType=getValueById('RType')
   var regNo=getValueById('regNo')
   var tmpRegNo=regNo;
	if (tmpRegNo!="")
		{
	    var regNoLength=10-regNo.length;     //�ǼǺŲ���   	
		for (var i=0;i<regNoLength;i++){
			tmpRegNo="0"+tmpRegNo;			
		}
		}
	regNo=tmpRegNo;	
    setValueById('regNo',regNo)              //�ǼǺŲ�ȫ���д
   var Price800=getValueById('Price800')
  
   $('#chkoppatdg').datagrid('options').url=$URL
   $('#chkoppatdg').datagrid('reload',{
       ClassName:'web.INSUAuditOP',
       QueryName:'OPAuditApp',
       RegNo:regNo,
       StartDate:stDate,
       EndDate:edDate,
       CheckAuditType:CheckAuditType,
       RType:RType,
       Price800:Price800,
       HospDr:HospDr
       });
       
       
}
//��ѯ����ҽ����Ŀ��ϸ
function QryPatOrd()
{    
     $('#chkoppatorddg').datagrid('options').url=$URL;
     $('#chkoppatorddg').datagrid('reload',{
       ClassName:'web.INSUAuditOP',
       QueryName:'QueryTariByOrd',
       OeOrdDr:SelOeOrdDr,
       ExpStr:"",
       
       });
   
}



//��ȡ�����ҽ����
function GetOEORIRowIdStr()
{
	
	 var SelRows=$HUI.datagrid('#chkoppatdg').getChecked();
	 var OEORIRowIdStr=""
      $.each(SelRows, function (index, row) {
	      
			var rowInString="",Insuflag="",Price="",Qty="",Amount="",orderRowid="",TarDr="",BZ="",ListFlag="";
			Insuflag=row.TInsuFlag; //�����Էѱ�־
			
		    if(OEORIRowIdStr==""){
			    OEORIRowIdStr=row.TabOEORIRowId
			    }
		    else{
			    OEORIRowIdStr=OEORIRowIdStr+"^"+row.TabOEORIRowId
			    }
			
		});
		
	return OEORIRowIdStr

}


//ҽ�����
function Audit_click()
{
   
   	var TabOEORIRowIdStr=GetOEORIRowIdStr()
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('��ʾ', '��ѡ������ҽ��', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"Y",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('��ʾ', '��˳ɹ�', 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('��ʾ', '���ʧ��,Error=' + rtn, 'error');
            }
        });
        
   
    return ;
        

}

//ҽ���������
function Resume_click()
{
	var TabOEORIRowIdStr=GetOEORIRowIdStr();
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('��ʾ', '��ѡ��Ҫ�������ҽ��', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('��ʾ', '���³ɹ�', 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('��ʾ', '����ʧ��,Error=' + rtn, 'error');
            }
        });
        
}

//ҽ���ܾ�
function Refuse_click()
{
	var TabOEORIRowIdStr=GetOEORIRowIdStr();
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('��ʾ', '��ѡ��Ҫ��˾ܾ�ҽ��', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"N",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('��ʾ', '���³ɹ�' , 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('��ʾ', '����ʧ��,Error=' + rtn, 'error');
            }
        });
}

//ҽ������
function InsuNotice_click()
{
    //InsuNotice(Guser,NowDate); //DHCINSUPort.js �˹�����δ�����׼��
     $.messager.alert('��ʾ', '�˽ӿ���Ҫ����ҽ������,���޴˹���', 'info');
}


//��֯�걨������
function BuildReportStr(row){
	
	            var TariCode=row.TariCode; 
  				var TariDesc=row.TariDesc; 
  				var InsuCode=row.InsuCode; 
  				var InsuDesc=row.InsuDesc; 
  				InsuDesc=InsuDesc.replace("�]","").replace("�^","")
  				var xmlb=row.xmlb; 
  				var sl=row.sl; 
  				var Price=row.Price; 
  				var Amount=row.Amount;
  				var SDate=row.SDate;
	            var EDate=row.EDate;
	            var ZZ=row.ZZ;
	            var MD=row.MD;
	            var InsuNo=row.InsuNo;
	            var States=row.States;
	            var RptType=row.RptType;
  				if (RptType=="41") {Amount=Price;}	
				//var str=InsuNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States
				var str=InsuNo+"|"+RptType+"|"+""+"|"+""+"|"+""+"|"+DiagCode+"|"+DiagDesc+"|"+"01"+"|"+InsuCode+"|"+InsuDesc+"|"+sl+"|"+SDate+"|"+SDate+"|"+EDate+"|"+GUserName+"|"+""+"|"+""+"|"+Amount+"|"+xmlb+"|"+""+"|"+ZZ+"|"+MD+"|"+""+"|"+""+"|"+"01"+"|"+"01"+"|"+GUserName+"|"+SDate+"|"+GUserName+"|"+TariCode+"|"+TariDesc+"|"+""+"|"+""+"|"+States

	
	}

//�걨�ϱ�
function Report_click(){
	 $.messager.alert('��ʾ', '�˽ӿ���Ҫ����ҽ������,���޴˹���', 'info');
	    var Amount="",flag=0,SDate="",EDate="",SucessCount=0;
	    var Month=now.getMonth()+1;
  		var Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
   		 SDate=String(Year)+String(Month)+String(Date)
  		 now.setDate(now.getDate()+7)
  		 Year=now.getFullYear();Month=now.getMonth()+1;Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
		EDate=String(Year)+String(Month)+String(Date)
		now.setDate(now.getDate()-7)
		var ZZ=getValueById('ZZ');  //֢״
  		var MD=getValueById('MD');  //Ŀ��
  		var InsuNo=getValueById('InsuNo');  //���˱��
  		var States=getValueById('States');  //�α���
  	    if (ZZ=="") {$.messager.alert('��ʾ','��¼��B֢״�I','info');return;}
  		if (DiagCode=="") {$.messager.alert('��ʾ','��ѡ��B�������ơB','info');return;}
  		if(States=="") {$.messager.alert('��ʾ','�α������ݴ���������¼��','info');return;}
  		var RptType=""
	    var SelRows=$HUI.datagrid('#chkoppatorddg').getChecked();
	    var OEORIRowIdStr=""
      $.each(SelRows, function (index, row) {
	      row.SDate=SDate;
	      row.EDate=EDate;
	      row.ZZ=ZZ;
	      row.MD=MD;
	      row.InsuNo=InsuNo;
	      row.States=States
	      row.RptType=RptType;
	      var ReportStr=BuildReportStr(row);
	      var ExpString=SelPatName+"^"+SelOeOrdDr;
		  var rtn=InsuReport(ReportStr,GUser,ExpString); //DHCINSUPort.js
	      	if (rtn==-1){
					 $.messager.alert('��ʾ',"��"+i+"�����������ϱ�ʧ��!�������������ϴ���"+i+"������",'error');
				}
				else
				{
					SucessCount=SucessCount+1	
				}
	      });
	
		 $.messager.alert('��ʾ',"�����ϱ��ɹ�����"+SucessCount +"��!",'success');
		 return ;

}	

//�ǼǺŻس�
function RegNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryOPChkPatInfo();
       
   }
}

//�����Żس�
function MedicareNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryOPChkPatInfo();
       
   }
}

//���˱��
function InsuNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       ReadCard_click();
       
   }
}



function ReadCard_click()
{
	
	var CardType="0",InsuNo="",States=""
	var InsuNo=getValueById("InsuNo"); //���˱��
	if ((String(InsuNo).length==15)||(String(InsuNo).length==18)) CardType="1"
    var ExpString="NJB^^"
	var rtn= InsuReadCard(0,GUser,InsuNo,CardType,ExpString); //DHCINSUPort.js
	if(rtn==-1)
	{
	    $.messager.alert('��ʾ', '����ʧ��,Error=' + rtn, 'error');
		return;
	}
	var TmpData=str.split("|")
	if (TmpData[0]!="0")  $.messager.alert('��ʾ', '����ʧ��,TmpData=' + TmpData, 'error');
 	else 
 	{ ///9037786^10110377^3501-5^������^Ů^^19360914000000^450106360914002^�����ж��������������ι�˾^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
		setValueById('InsuNo',TmpData1[0]) //���˱��
		CenterNo=TmpData[2].split("^")[8]
		if(SelPatName!=TmpData1[3])
		{
			$.messager.alert('��ʾ',"������һ��,ҽ����������:"+TmpData1[3],'info');
			disableById('BtnAudit')
			return ;
			
	    }else
	    {
	        enableById('BtnAudit');
		 }
		CenterNo=TmpData[2].split("^")[8]
		/*if (CenterNo=="450122")	States="������"
		else if (CenterNo=="450123")	States="¡����"
		else if (CenterNo=="450124")	States="��ɽ��"
		else if (CenterNo=="450125")	States="������"
		else if (CenterNo=="450126")	States="����"  
		else if (CenterNo=="450127")	States="������"
		else {States="������";CenterNo=="450100";}*/
		setValueById('States',States)
	
	 	}
}

function SetValue(value)
{
   if(value == undefined)
   {
       value="" ;
   }
   
   value=value.toString().replace(/\"/g, "");
   value=value.toString().replace(/\?/g,"");
   return value;
}

 /*ͷ�˵���ֵ*/
function setEprMenuForm(episodeId, patientId) {
	var frm = dhcsys_getmenuform();
	if (frm && (frm.EpisodeID.value != episodeId)) {
		frm.EpisodeID.value = episodeId;
		frm.PatientID.value = patientId;
	}
}
