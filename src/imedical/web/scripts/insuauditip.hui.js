/**
 * סԺҽ��ҽ�����JS
 * FileName:insuauditip.hui.js
 * DingSH 2020-02-25
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
var HospDr=session['LOGON.HOSPID'];
var GUser=session['LOGON.USERID'];
var GUserName=session['LOGON.USERNAME'];
var SelAdmDr="";
var SelBillDr="" 
var theInterval;
var SelPatModifyAfterRowObj;
var PatOrd={
	  curRow:null,
	  cunIndex:-1
	}
var PatOrdLst={
	  curRow:null,
	  cunIndex:-1
	}
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
 
 //#4����Ԫ��
 $('#DiagWin').hide();
 $('#PatOrdLstWin').hide();    
 //$('#stDate').datebox('setValue','08/01/2020');
// $('#edDate').datebox('setValue','08/01/2020');
 //#5����Ĭ������
 setDefDateValue();
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


/**
* ȡ��ǰʱ��
*/
function getCurDateTime() {
	return 
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
   
   //��ʼ���
   $HUI.linkbutton('#btnAuditSt',
   {
     onClick: function()
           {
             btnAuditSt_click();
            }
    });    
  //��ʼ�Զ���ѯ           
   $HUI.linkbutton('#btnSearchAutoSt',
   {
      onClick: function()
           {
             theInterval=setInterval("QryChkPatInfo()",10000);
            }
    });  
  //ֹͣ�Զ���ѯ     
   $HUI.linkbutton('#btnSearchAutoStp',
    {
       onClick: function()
            {
              clearInterval(theInterval);
            }
     });     
  //ҽ��������     
   $HUI.linkbutton('#btnAudit',{
      onClick: function()
           {
              Audit_click();
            }
       });
   //����   
   $HUI.linkbutton('#btnSave',{
           onClick: function()
           {
              btnSave_click() ;
            }
       });

   //�������   
   $HUI.linkbutton('#btnAuditReset',{
           onClick: function()
           {
             BtnAuditBack_click();
            }
       });    
  //���״̬
   $HUI.combobox("#chkType",{
      onSelect: function(rec)
      {
	     QryChkPatInfo() ;  
	   }
   });
   
   //��ѯ����
   $HUI.combobox("#searchType",{
      onSelect: function(rec)
      {
	     QryChkPatInfo() ;  
	   }
   });
   
   
  
   }

//��ʼ����������Ϣgd
function InitPatDg() {
   //��ʼ��datagrid
   $HUI.datagrid("#chkpatdg",{
	   fit: true,
       url: $URL,
       singleSelect: true,
       border: false,
       data: [],
       columns:[[
           {field:'TabRegNo',title:'�ǼǺ�',width:120,align:'left'},
           {field:'TabPatName',title:'����',width:100},
           {field:'TabCTDesc',title:'��������',width:150},
           {field:'TabPatType',title:'��������',width:100,align:'center'},
           {field:'TabDiagDesc',title:'���',width:160
           ,formatter: function (value, row, index) {
                          if(value!="")
                          {
                           return "<a class='hisui-tooltip' href='#' title='�鿴�����ϸ' onclick='showDiagWin("+JSON.stringify(row)+")' \'>"+value+"</a>";
                          }
                   }
           
           },
           {field:'TabDemo',title:'��ע ',width:100,
            editor:{
                       type:'text',
                   }},
           {field:'TabAuditFlag',title:'��˱��',width:80,align:'center'},
           {field:'TabAuditUserName',title:'�����',width:120,align:'center'},
           {field:'TabAuditDate',title:'�������',width:120},
           {field:'TabAuditTime',title:'���ʱ��',width:80},
           {field:'TabAdmDate',title:'��Ժ����',width:100},
           {field:'TabDischgDate',title:'��Ժ����',width:100},
           {field:'TabPoint',title:'�Էѱ���',width:80},
           {field:'TabTolAmount',title:'�ܽ��',width:100},
           {field:'TabSex',title:'�Ա�',width:60},
           {field:'TMediCare',title:'������',width:100},
           {field:'TabBillDr',title:'�ʵ���',width:100},
           {field:'TabReceiveFlag',title:'����״̬',width:40,hidden:true},
           {field:'TabAdmRowid',title:'TabAdmRowid',width:40,hidden:true},
           
       ]],
       pageSize: 10,
       pagination:true,
       onClickRow : function(rowIndex, rowData) {
           SelAdmDr=rowData.TabAdmRowid;
           SelBillDr=rowData.TabBillDr
          var DivFlag=tkMakeServerCall("web.DHCINSUDivideSubCtl","GetDivSubUpConutByBillDr",SelBillDr,"");
	     if (DivFlag>0)
	      {  
	        $.messager.alert('��ʾ', '�û����Ѿ�ҽ�������ϴ�,���ܽ��з��õ�����','info');
	         disableById('btnSave')
	        return;
	      }
           if(rowData.TabAuditFlag=="��ʼ���")
           {
	           
	           disableById('btnAuditSt')
	           enableById('btnAudit')
	           enableById('btnSave')
	           QryPatOrd();
	       }
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
	       
	       /*$HUI.datagrid('#chkpatOrddg',{selectOnCheck:false,
	                          checkOnSelect:false,
	                          singleSelect:true
	       })*/
	       
	       
	       
       },
       onClickCell:function(index,field,value){
           onClickCell(index,field);
           
           },
       onLoadSuccess:function(data)
       {
           //alert(256)
           SelPatRowObj=null;
           SelAdmDr=""
           SelBillDr=""
           QryPatOrd()
       }
   });
   
}

//��ʼ������˻���ҽ��gd
function InitPatOrdDg()
{
    //��ʼ��datagrid
   $HUI.datagrid("#chkpatOrddg",{
	    url: $URL,
	   fit: true,
       singleSelect: false,
       rownumbers: true,
       selectOnCheck: true,
	   checkOnSelect: false,
       border: false,
       pageSize: 99999999,
       pagination:false,
       toolbar: [],
       data: [],
       frozenColumns:
       [[ { 
           field: 'TListFlag',
           width: 40,
           title: '����',
           align: 'center',
           formatter: function (value, row, index) {
                          if(value!="")
                          {

                           return "<img class='myTooltip' style='width:60' title='�鿴ҽ����ϸ' onclick='showPatOrdLstWin("+JSON.stringify(row)+")'  src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png' style='border:0px;cursor:pointer' \'>";
                           
                          }
                   }
         },
          {field:'ck',title:'ck',width:10,checkbox:true}
         
         
          ]],
       columns:[[
          
           {field:'TTarDr',title:'TTarDr',width:10,hidden:true},
           {field:'TOEORI',title:'TOEORI',width:10,hidden:true},
           {field:'Tchangeflag',title:'Tchangeflag',width:10,hidden:true},
           {field:'TTarDesc',title:'��Ŀ����',width:180},
           {field:'Txmdj',title:'��Ŀ�ȼ�',width:100,
            styler:function(value,row,index)
             {
	            
	            return 'color:blue' ;
	            
	            }
           },
           {field:'TPrice',title:'����',width:80,align:'right',
              formatter:function(val,rowData,rowIndex){
               if(val!=null)
                return Number(val).toFixed(4);
                }
           },
           {field:'TQty',title:'����',width:80,align:'center'},
           {field:'TAmount',title:'�ܽ��',width:100,align:'right',
	           formatter:function(val,rowData,rowIndex){
               if(val!=null)
                return Number(val).toFixed(2);
                }
            
            },
            {field:'TInsuFlag',title:'����Ϊ�Է�',width:100,align:'center',
            formatter:function(val,rowData,rowIndex){
                  return (val=="Y") ? "��" : "��";
                },
             editor:{
	             type:'switchbox',
	             options:{   
		         onClass:'primary',
	             offClass:'gray',
	             onText:'��',
	             offText:'��',
	             onSwitchChange:function(event,obj){
		                RowTInsuFlagOnChange(obj.value,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
		             }
		             }
	             }
           },
            
           {field:'TOrderDate',title:'ҽ������',width:90,align:'center'},
           {field:'TOrderTime',title:'ҽ��ʱ��',width:80,align:'center'},
           {field:'TDocName',title:'ҽ��¼����',width:90,align:'center'},
           {field:'Tybbz',title:'������Ϣ',width:130},
           {field:'TUomDesc',title:'��λ',width:60},
           {field:'TDemo',title:'��ע',width:100},
           {field:'TDHCTarCate',title:'��Ŀ����',width:80},
           {field:'TarInsuFlag',title:'ԭʼ�ȼ�',width:140},
           {field:'TArcimDesc',title:'ҽ������',width:140},
           {field:'TInsuTarCode',title:'ҽ����Ŀ����',width:120},
           {field:'TInsuTarDesc',title:'ҽ����Ŀ����',width:140},
           {field:'TTarCode',title:'ҽԺ��Ŀ����',width:120},
           {field:'MotherAdmFlag',title:'MotherAdmFlag',width:100},
           {field:'TmpOutDrugFlag',title:'TmpOutDrugFlag',width:150},
           
           
       ]],
    
       onClickRow : function(rowIndex, rowData) {
           onClickOrdRow(rowIndex,rowData)
           PatOrd.curRow = rowData;
           PatOrd.curIndex = rowIndex
          RowTInsuFlagCheck('chkpatOrddg',rowIndex, rowData) ;
       },
       onLoadSuccess:function(data)
       {
          
       }
   });
}

//��ѯ��˻�����Ϣ
function QryChkPatInfo()
{
   SelAdmDr="",SelBillDr=""
   var stDate=getValueById('stDate')
   var edDate=getValueById('edDate')
   var searchType=getValueById('searchType')
   var chkType=getValueById('chkType')
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
   
   var medicareNo=getValueById('medicareNo')
   $('#chkpatdg').datagrid('reload',{
       ClassName:'web.INSUAuditIP',
       QueryName:'IPAuditApp',
       RegNo:regNo,
       StartDate:stDate,
       EndDate:edDate,
       CheckAuditType:"",
       DepList:"",
       CheckInPat:searchType,
       CheckAuditFlag:chkType,
       ReceiveFlag:"",
       MediCare:medicareNo,
       HospDr:HospDr
       });
       
       ///
}
//��ѯ����ҽ����Ŀ��ϸ
function QryPatOrd()
{    
     $('#chkpatOrddg').datagrid('reload',{
	
       ClassName:'web.INSUAuditIP',
       QueryName:'IPAuditAppDetail',
       AdmDr:SelAdmDr,
       BillDr:SelBillDr,
       
       });
   
}

//��ʼ���
function btnAuditSt_click()
{
    //Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
       $.messager.alert('��ʾ', '��ѡ������˻��߼�¼', 'info') ;
       return ;
	}
    if(SelAdmDr=="")
    {
       $.messager.alert('��ʾ', '����Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
       return ;
    }
    if(SelBillDr=="")
    {
       $.messager.alert('��ʾ', '�ʵ��Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
       return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo
    var AuditUserName=SelPatModifyAfterRowObj.TabAuditUserName
	if ((AuditUserName!="")&&(AuditUserName!=GUserName)){
		$.messager.alert('��ʾ', '�û�������'+SelPatModifyAfterRowObj.TabAuditUserName+'�����,�������', 'info')
		return;
		}
   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"��ʼ���"+"^"+BZ+"^^^^^^^^^^^"
	
	 $.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('��ʾ', '��˿�ʼ', 'success') ;
              QryChkPatInfo() ;  
            } else {
                $.messager.alert('��ʾ', '��˿�ʼʧ��,Error=' + rtn, 'error') ;
            }
        });
        
    
}

//������
function Audit_click()
{
    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
      $.messager.alert('��ʾ', '��ѡ������˻��߼�¼', 'info') ;
      return ;
	 }
    if(SelAdmDr=="")
    {
      $.messager.alert('��ʾ', '����Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
      return ;
    }
    if(SelBillDr=="")
    {
     $.messager.alert('��ʾ', '�ʵ��Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
     return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo ;
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('��ʾ', '�û�������'+SelPatModifyAfterRowObj.TabAuditUserName+'�����,�������', 'info')
		return ;
	}
		
	//Save_Click();  //������ʱ�Զ����� 2011 12 26

   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"���"+"^"+BZ+"^^^^^^^^^^^"
	$.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('��ʾ', '������' + rtn, 'success');
               QryChkPatInfo() ; 
            } else {
                $.messager.alert('��ʾ', '������ʧ��,Error=' + rtn, 'error');
            }
        });
        
        
        
}

//�������
function BtnAuditBack_click()
{	
	endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
        $.messager.alert('��ʾ', '��ѡ������˻��߼�¼', 'info') ;
        return ;
	 }
    if(SelAdmDr=="")
    {
        $.messager.alert('��ʾ', '����Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
        return ;
     }
    if(SelBillDr=="")
    {
        $.messager.alert('��ʾ', '�ʵ��Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info');
        return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('��ʾ', '�û�������'+SelPatModifyAfterRowObj.TabAuditUserName+'�����,�������', 'info')
		return;
	 }
     //Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
    //var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"���"+"^"+BZ+"^^^^^^^^^^^"
   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"��ʼ���"+"^"+BZ+"^^^^^^^^^^^"
	$.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('��ʾ', '������˿�ʼ', 'success');
               QryChkPatInfo() ;
            } else {
                $.messager.alert('��ʾ', '�������ʧ��,Error=' + rtn, 'error');
            }
        });
}



//��Ŀ�����Էѵ��ú���
function RowTInsuFlagOnChange(val,dgId,index,row){
	var selPatRow=$HUI.datagrid("#chkpatdg").getSelected()
    if (selPatRow.TabAuditFlag!="��ʼ���"){
	   $.messager.alert('��ʾ', '�ǿ�ʼ���״̬,���ܵ�����Ŀ', 'info');
	    return ;
	    }
	 if ((selPatRow.TabAuditUserName!=GUserName))
	{
		$.messager.alert('��ʾ', '�û�������'+selPatRow.TabAuditUserName+'�����,���ܵ�����Ŀ', 'info')
		return;
	 }    
     $HUI.datagrid('#'+dgId).checkRow(index);
	  if(undefined==row) return;   
	  var InsuFlag="" ;   
	  var Txmdj=row.Txmdj
		  if(undefined!=Txmdj) {
		      if(val) {
			      InsuFlag="N";
			      if (row.Txmdj.indexOf("-")<0) {
				       Txmdj=row.Txmdj+"->����";	
		           }
			      
			   } else  {
				      InsuFlag="Y";
				       Txmdj=Txmdj.split("-")[0] ;
				      
			   }
            }
	  HISUIDataGrid.setFieldValue('Txmdj',Txmdj,index,dgId);
	  var TarDr,OEORIDr
	  if (dgId=='chkpatOrddg')
	   {
	    TarDr=row.TTarDr
	     OEORIDr=""
	   }
	   if (dgId=='patordlstdg')
	   {
	     TarDr=getValueById('lstTarDr')
	     OEORIDr=row.TOEExeDr
	   }
	  SaveInsuFlag(TarDr,OEORIDr,InsuFlag);
	  
	
	  
	  
	}

//����Ϊ�Է�У��
function RowTInsuFlagCheck(dgId,index,row)
{
	
  var selPatRow=$HUI.datagrid("#chkpatdg").getSelected()
    if (selPatRow.TabAuditFlag!="��ʼ���"){
	   $.messager.alert('��ʾ', '�ǿ�ʼ���״̬,���ܵ�����Ŀ', 'info');
	    return ;
	    }
	 if ((selPatRow.TabAuditUserName!=GUserName))
	{
		$.messager.alert('��ʾ', '�û�������'+selPatRow.TabAuditUserName+'�����,���ܵ�����Ŀ', 'info')
		return;
	 }     
	ed= $HUI.datagrid('#'+dgId).getEditor({index: index, field: "TInsuFlag"});
	
	

					
	var ckval=false;
	if (row.TInsuFlag=="Y")
	{
		ckval=true
		
	}
	if (ed) {
		$(ed.target).switchbox('setValue',ckval) ;
	}
	
}

//����Ϊ�Է�checkbox�ı�ʱ����
function SaveInsuFlag(TarDr,OEORIDr,InsuFlag)
{
	
	var BillDr=SelBillDr ;
	$.m(
	  {
		ClassName:'web.INSUAuditIP',
		MethodName:'SaveInsuFlag',
		BillDr:BillDr,
		TarDr:TarDr,
		OEORIDr:OEORIDr,
		InsuFlag:InsuFlag
	  },
	   function(rtn)
	   {
		   // $.messager.alert('��ʾ', '����,rtn=' + rtn, 'info');
		   
		}
	
	
	);
	
}
//��˱���ҽ����Ŀ��ϸ
function btnSave_click()
{

    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
        $.messager.alert('��ʾ', '��ѡ������˻��߼�¼', 'info') ;
        return ;
	 }
    if ((SelPatModifyAfterRowObj.TabAuditFlag!="��ʼ���"))
     {
		$.messager.alert('��ʾ', "'��˱��' ���� '��ʼ���' ״̬,���ɱ���", 'info') ;
		return ;
	 }  
    if(SelAdmDr=="")
    {
        $.messager.alert('��ʾ', '����Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
        return
     }
    if(SelBillDr=="")
    {
        $.messager.alert('��ʾ', '�ʵ��Ų���Ϊ�գ���ѡ������˻��߼�¼', 'info') ;
        return ;
    }
  
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('��ʾ', '�û�������'+SelPatModifyAfterRowObj.TabAuditUserName+'�����,�������', 'info')
		return ;
	}    
      OrdEndEditing()
     //s val=##Class(%CSP.Page).Encrypt($lb("")) 
     var SuccNum=0, ErrorNum=0,ErrMsg="" ;
      var SelRows=$HUI.datagrid('#chkpatOrddg').getChecked();
      $.each(SelRows, function (index, row) {
	      
			var rowInString="",Insuflag="",Price="",Qty="",Amount="",orderRowid="",TarDr="",BZ="",ListFlag="";
			Insuflag=row.TInsuFlag; //�����Էѱ�־
			orderRowid=row.TOEORI
			TarDr=row.TTarDr	
            Price=row.TPrice
            Qty=row.TQty
            Amount=row.TAmount
            ListFlag=row.TListFlag
            if(ListFlag=="��ϸ"){orderRowid="";}
            orderRowid="" //���ϵͳû��ִ�м�¼��ȡ��ע�� Zhan 20160413
			BZ=row.TDemo
			rowInString="^"+SelAdmDr+"^"+SelBillDr+"^"+orderRowid+"^"+TarDr+"^"+""+"^"+Insuflag+"^"+""+"^"+Price+"^"+Qty+"^"+Amount+"^"+1+"^"+GUser+"^"+GUserName+"^^^^"+BZ+"^^^^^^^^^^^"
			$.m({
                  ClassName: "web.INSUAuditIP",
                  MethodName: "SaveAuditLog",
                  InString: rowInString,
                }, function (rtn) {
                   if (rtn > 0) 
                     {
                        //$.messager.alert('��ʾ', '������˿�ʼ', 'success');  
                         SuccNum=SuccNum+1       
                     } else 
                      {
                         //$.messager.alert('��ʾ', '�������ʧ��,Error=' + rtn, 'error');
                         ErrorNum=ErrorNum+1
                         ErrMsg=ErrMsg+'|�շ���ĿDr='+TarDr+"����ʧ��,ErrNo:"+rtn
                       }
                  });
			
		    
		});
		
		$.messager.alert('��ʾ', '����ɹ�', 'success',function(){
			QryPatOrd();	
		});
		return ;
}

//�ǼǺŻس�
function RegNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryChkPatInfo();
       
   }
}

//�����Żس�
function MedicareNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryChkPatInfo();
       
   }
}

//�����Ϣ�б�չʾ
function showDiagWin(rowData)
{       
   
   InitPatDiagDg(rowData)
   $('#DiagWin').show(); 
       $HUI.dialog("#DiagWin",{
           title:"�����ϸ��Ϣ",
           height:300,
           width:420,
           //collapsible:true,
           modal:false,
           iconCls: 'icon-w-list'
  
       })
   
}
//��ʼ�����gd
function InitPatDiagDg(rowData)
{
   //��ʼ��datagrid
   $HUI.datagrid("#patdiagdg",{
       url:$URL+'?ClassName='+"web.INSUAuditIP"+'&QueryName='+"GetDiagnosInfo"+"&AdmDr="+rowData.TabAdmRowid,
        width: '100%',
        border: false ,
       singleSelect: true,
       columns:[[
           {field:'DiagnosNum',title:'���',width:60,align:'center'},
           {field:'DiagName',title:'�������',width:150},
           {field:'MedicalRecord',title:'��ϱ�ע',width:80},
           {field:'ICDCode',title:'ICD���',width:103}
          
       ]],
       pageSize: 10,
       pagination:true,
       onBeforeLoad:function(param){
			//param.ClassName='web.INSUAuditIP';
			//param.QueryName='GetDiagnosInfo';
			//param.AdmDr=SelAdmDr;
			
		},		
       onLoadSuccess:function(data)
       {
          
       }
       
   });
   
}

//ҽ����ϸϢ�б�չʾ+����
function showPatOrdLstWin(rowData)
{
	
  InitPatOrdLstDg(rowData)
   $('#PatOrdLstWin').show(); 
       $HUI.dialog("#PatOrdLstWin",{
           title:"ҽ����ϸ��Ϣ",
           height:400,
           width:900,
           //collapsible:true,
           modal:true,
           iconCls: 'icon-w-list',
           onClose:function()
           {
	           
	            PatOrdLst.curIndex = -1;
                PatOrdLst.curRow = null;
	            ordLstEditIndex = undefined;
	        }
  
       })
	
}

//��ʼ��ҽ����Ŀ��ϸgd
function InitPatOrdLstDg(rowData)
{
	setValueById('lstTarDr',rowData.TTarDr);
   //��ʼ��datagrid
   $HUI.datagrid("#patordlstdg",{
       url:$URL+'?ClassName='+"web.INSUAuditIP"+'&QueryName='+"AuditDetailsList"+'&AdmDr='+SelAdmDr+'&BillDr='+SelBillDr+'&TarDr='+rowData.TTarDr+'&MotherAdmFlag='+rowData.MotherAdmFlag+'&TmpOutDrugFlag='+rowData.TmpOutDrugFlag+'&Price='+rowData.TPrice,
       width: '100%',
	   selectOnCheck: true,
	   checkOnSelect: false,
       border:false,
       pagination:true,
       pageSize:10,
	   pageList:[10,20,30],
       data: [],
        frozenColumns:
       [[ 
          {field:'lstck',title:'lstck',width:10,checkbox:true}
          ]],
       columns:[[
           {field:'TTarDesc',title:'��Ŀ����',width:160},
           {field:'Txmdj',title:'��Ŀ�ȼ�',width:100},
           {field:'TPrice',title:'����',width:60,align:'center'},
           {field:'TQty',title:'����',width:60,align:'center'},
           {field:'TAmount',title:'���',width:80,align:'center'},
           {field:'TInsuFlag',title:'����Ϊ�Է�',width:100,align:'center',
            formatter:function(val,rowData,rowIndex){
                  return (val=="Y") ? "��" : "��";
                },
             editor:{
	             type:'switchbox',
	             options:{   
		         onClass:'primary',
	             offClass:'gray',
	             onText:'��',
	             offText:'��',
	             onSwitchChange:function(event,obj){
		                RowTInsuFlagOnChange(obj.value,"patordlstdg",PatOrdLst.curIndex,PatOrdLst.curRow);
		             }
		             }
	             }
           },
           {field:'TOEORIDr',title:'TOEORIDr',width:80,hidden:true},
           {field:'TOeordDate',title:'ҽ������',width:90,align:'center'},
           {field:'TOeordTime',title:'ҽ��ʱ��',width:80,align:'center'},
           {field:'TArcimDesc',title:'ҽ������',width:80},
           {field:'TOEExeDr',title:'TOEExeDr',width:80}
           
          
       ]],
       onBeforeLoad:function(param){
			//param.ClassName='web.INSUAuditIP';
			//param.QueryName='GetDiagnosInfo';
			//param.AdmDr=SelAdmDr;
			
		},	
		onClickRow : function(rowIndex, rowData) {
           onClickOrdLstRow(rowIndex)
           PatOrdLst.curIndex=rowIndex;
           PatOrdLst.curRow=rowData;
           
           RowTInsuFlagCheck('patordlstdg',rowIndex, rowData) ;
       }
       
   });
   
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

 var editIndex = undefined;
 function endEditing(){
           if (editIndex == undefined){return true}
           if ($('#chkpatdg').datagrid('validateRow', editIndex)){
               $('#chkpatdg').datagrid('endEdit', editIndex);
               SelPatModifyAfterRowObj = $('#chkpatdg').datagrid('getRows')[editIndex];
               editIndex = undefined;
               return true;
           } else {
               return false;
           }
       }
      
     
  function onClickCell(index, field)
       {
           if (editIndex != index){
               if (endEditing()){
                   $('#chkpatdg').datagrid('selectRow', index)
                           .datagrid('beginEdit', index);
                   var ed = $('#chkpatdg').datagrid('getEditor', {index:index,field:field});
                   if (ed){
                       ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
                   }
                   
                   editIndex = index;
               } else {
                   setTimeout(function(){
                       $('#chkpatdg').datagrid('selectRow', editIndex);
                   },0);
               }
           }
       }
   
var ordEditIndex=undefined;
var OrdmodifyBeforeRow = {};
var OrdmodifyAfterRow = {};
function OrdEndEditing(){
       if (ordEditIndex == undefined){return true}
       if ($('#chkpatOrddg').datagrid('validateRow', ordEditIndex)){
           //�б���������ʵ��
           $('#chkpatOrddg').datagrid('endEdit', ordEditIndex);
           OrdmodifyAfterRow = $('#chkpatOrddg').datagrid('getRows')[ordEditIndex];
           
           
			// tangzf 20200407 start
			//var thisEd = $('#chkpatOrddg').datagrid('getEditor', {index: ordEditIndex, field: 'TInsuFlag'});
			//if (thisEd) {
				//$HUI.switchbox(thisEd.target,'setValue',OrdmodifyAfterRow.TInsuFlag);
				//RowTInsuFlagOnChange(OrdmodifyAfterRow.TInsuFlag,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
				HISUIDataGrid.setFieldValue('TInsuFlag',(OrdmodifyAfterRow.TInsuFlag=="��") ? "Y" : "N",ordEditIndex,'chkpatOrddg');
				var td = $('.datagrid-view').find('.datagrid-body td[field="' + 'TInsuFlag' + '"]')[ordEditIndex];
				var div = $(td).find('div')[0];
				$(div).text((OrdmodifyAfterRow.TInsuFlag=="Y") ? "��" : "��");
			//}
			// tangzf 20200407 end ����ѡ�к� ����Ĭ��Ϊ��

			
           ordEditIndex = undefined;
           return true;
       } else {
           return false;
       }
   }
function onClickOrdRow(index,rowData){
   if (ordEditIndex!=index) {
       if (OrdEndEditing()){
           $('#chkpatOrddg').datagrid('selectRow', index)
           $('#chkpatOrddg') .datagrid('beginEdit', index);
           ordEditIndex = index;
          // OrdmodifyBeforeRow = $.extend({},$('#chkpatOrddg').datagrid('getRows')[ordEditIndex]);
       } else {
           $('#chkpatOrddg').datagrid('selectRow', ordEditIndex);
       }
   }

}



var ordLstEditIndex=undefined;
function OrdLstEndEditing(){
       if (ordLstEditIndex == undefined){return true}
       if ($('#patordlstdg').datagrid('validateRow', ordEditIndex)){
           //�б���������ʵ��
           $('#patordlstdg').datagrid('endEdit', ordLstEditIndex);
          // tangzf 20200407 start
         var selectRow = $('#patordlstdg').datagrid('getRows')[ordLstEditIndex];
			//var thisEd = $('#chkpatOrddg').datagrid('getEditor', {index: ordEditIndex, field: 'TInsuFlag'});
			//if (thisEd) {
				//$HUI.switchbox(thisEd.target,'setValue',OrdmodifyAfterRow.TInsuFlag);
				//RowTInsuFlagOnChange(OrdmodifyAfterRow.TInsuFlag,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
				HISUIDataGrid.setFieldValue('TInsuFlag',(selectRow.TInsuFlag=="��") ? "Y" : "N",ordLstEditIndex,'patordlstdg');
				var td = $('#PatOrdLstWin').find('td[field="' + 'TInsuFlag' + '"]')[ordLstEditIndex+1];
				var div = $(td).find('div')[0];
				$(div).text((selectRow.TInsuFlag=="Y") ? "��" : "��");
			//}
			// tangzf 20200407 end ����ѡ�к� ����Ĭ��Ϊ��
           ordLstEditIndex = undefined;
           return true;
       } else {
           return false;
       }
   }
function onClickOrdLstRow(index){
   if (ordLstEditIndex!=index) {
       if (OrdLstEndEditing()){
           $('#patordlstdg').datagrid('selectRow', index)
                   .datagrid('beginEdit', index);
           ordLstEditIndex = index;
          // OrdmodifyBeforeRow = $.extend({},$('#chkpatOrddg').datagrid('getRows')[ordEditIndex]);
       } else {
           $('#patordlstdg').datagrid('selectRow', ordLstEditIndex);
       }
   }
}