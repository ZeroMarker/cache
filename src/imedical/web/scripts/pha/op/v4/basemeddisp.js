/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-����ҩ��ҩ
 *createdate:2020-11-11 
 *creator:zhaozhiduan
 */
 
var hisPatNoLen=""; //�ǼǺų���
var Com_Pid="";
$(function () {
    GetPhaHisCommonParmas();    //�ǼǺų���
    InitDict();
    InitGridBaseMedLoc();
    InitGridBaseMedTotal();
    InitGridBaseMedDetail();
    $("#btnFind").on("click", Query);
    $("#btnDisp").on("click", ConfirmFY);
    $("#btnClean").on("click", Clean);
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#conPatNo").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, hisPatNoLen);
                $(this).val(newpatno);
                if(newpatno==""){return;}
                Query();
            }
        }
    });

    $("#tabsOne").tabs({
        onSelect:function(title){
            if(Com_Pid==""){
                return;
            }
            var Params=GetParams();
            var tab = $('#tabsOne').tabs('getSelected');
            var index = $('#tabsOne').tabs('getTabIndex',tab);
            if(index==0){
                $("#gridBaseMedTotal").datagrid("query",{
                    inputStr:Params,
                    pid:Com_Pid
                }); 
            }else if(index==1){
                $("#gridBaseMedDetail").datagrid("query",{
                    inputStr:Params,
                    pid:Com_Pid
                });  
            }                   
        }
    })
    //�����뿪���tmp
    window.addEventListener('beforeunload', function(event){
        if (navigator.sendBeacon){
             var killUrl = $URL+'?ClassName=PHA.OP.BaseMedDisp.Query&MethodName=KillTmp&pid='+Com_Pid;
             if ('undefined' !== typeof websys_getMWToken){
                 killUrl += "&MWToken=" + websys_getMWToken();
             }
             navigator.sendBeacon(killUrl, '');
         }else{
             KillTmp();
         }
     });
 })
 function InitDict(){
     $('#conPhStDate').datebox('setValue', 't-1');
     $('#conPhEndDate').datebox('setValue', 't');
     // �������
     PHA.ComboBox('conPhLoc',{
         editable:false, 
         url: PHAOP_STORE.PHLOC().url,
         onLoadSuccess: function () {
             var datas = $("#conPhLoc").combobox("getData");
             for (var i = 0; i < datas.length; i++) {
                 if (datas[i].RowId == session['LOGON.CTLOCID']) {
                     $("#conPhLoc").combobox("setValue", datas[i].RowId);
                     $("#conPhLoc").combobox("options").defVal = datas[i].RowId;
                     break;
                 }
             }
         }
         
     });
 
 }
 //����ҩ�����б�
 function InitGridBaseMedLoc(){
     var columns = [[{
                 field: 'Pid',
                 title: 'Pid',
                 width: 100,
                 hidden: true
             },{
                 field: 'LocRowId',
                 title: 'ID',
                 width: 100,
                 hidden: true
             },
             {
                 field: 'LocDesc',
                 title: '��������',
                 width: 100
             }
         
     ]];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.OP.BaseMedDisp.Query',
             QueryName: 'QueryBaseMedLoc',
             inputStr:  ''
         },
         pagination: true,
         columns: columns,
         fitColumns: true,
         rownumbers: true,
         onRowContextMenu:"",
         
         toolbar: [],
         onSelect: function(rowIndex, rowData) {
             if(rowData){
                 $('#gridBaseMedTotal').datagrid('clear');
                 $('#gridBaseMedDetail').datagrid('clear');
                 var Params=GetParams();
                 var pid=rowData.Pid
                 var tab = $('#tabsOne').tabs('getSelected');
                 var index = $('#tabsOne').tabs('getTabIndex',tab);
                 if(index==0){
                     $("#gridBaseMedTotal").datagrid("query",{
                         inputStr:Params,
                         pid:pid
                     }); 
                 }else if(index==1){
                     $("#gridBaseMedDetail").datagrid("query",{
                         inputStr:Params,
                         pid:pid
                     }); 
                 }
             }
         },
         onLoadSuccess: function(data) {
             if(data.total>0){
                 $('#gridBaseMedLoc').datagrid("selectRow",0);
                 Com_Pid=data.rows[0].Pid;
                 
             }
         }
     };
     PHA.Grid('gridBaseMedLoc', dataGridOption);
 }
 //  ����ҩ����
 function InitGridBaseMedTotal(){
     var columns = [[
         {field: 'InciId',title: 'ID',width: 100,hidden: true},
         {field: 'InciCode',title: 'ҩƷ����',width: 100},
         {field: 'InciDesc',title: 'ҩƷ����',width: 250},
         {field: 'Spec',title: '���',width: 120},
         {field: 'InciQty',title: '����',width: 60},
         {field: 'InciUomDesc',title: '��λ',width: 80},
         {field: 'ManfDesc',title: '������ҵ',width: 200},
         {field: 'Pid',title:'����id',width: 80,hidden:true} //
         
     ]];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.OP.BaseMedDisp.Query',
             QueryName: 'QueryBaseMedTotal',
             inputStr:  ''
         },
         pagination: true,
         columns: columns,
         fitColumns: true,
         onRowContextMenu:"",
         toolbar: [],
         onLoadSuccess: function(data) {
             if(data.total>0){
                 $('#gridBaseMedTotal').datagrid("selectRow",0);
                 Com_Pid=data.rows[0].Pid;
                 SavetofitlerAll(data,"Y")
             }
             
         }
     };
     PHA.Grid('gridBaseMedTotal', dataGridOption);
 }
 // ����ҩ��ϸ
 function InitGridBaseMedDetail(){
     var columns = [[
         {field: 'CheckFlag',checkbox:true },
         {field: 'AdmId',title: 'AdmId',width: 100,hidden: true},
         {field: 'PatNo',title: '�ǼǺ�',width: 100},
         {field: 'PatName',title: '����',width: 100},
         {field: 'PrtDate',title: '�շ�����',width: 100},
         {field: 'PrescNo',title: '������',width: 100},
         {field: 'PatAge',title: '����',width: 100,hidden: true},
         {field: 'PatSex',title: '�Ա�',width: 100,hidden: true},
         {field: 'DiagDesc',title: '���',width: 100},
         {field: 'PrescItmArr',title: 'ҩƷ����',width: 250,formatter: PHA_OP.Grid.Formatter.InciGroup},
         {field: 'Qty',title: '����',width: 60,formatter: PHA_OP.Grid.Formatter.QtyUomGroup},
         {field: 'InstDesc',title: '�÷�',width: 60,formatter: PHA_OP.Grid.Formatter.InstGroup},
         {field: 'DoseQty',title: '����',width: 60,formatter: PHA_OP.Grid.Formatter.DosageGroup},
         {field: 'FreqDesc',title: 'Ƶ��',width: 60,formatter: PHA_OP.Grid.Formatter.FreqGroup},
         {field: 'Pid',title:'����id',width: 80,hidden:true} //
     ]];
     var dataGridOption = {
         url: $URL,
         queryParams: {
             ClassName: 'PHA.OP.BaseMedDisp.Query',
             QueryName: 'QueryBaseMedDetail',
             inputStr:  ''
         },
         columns: columns,
         singleSelect: true,
         selectOnCheck: false,
         checkOnSelect: false,
         rownumbers:true,
         fitColumns: true,
         pagination: false,
         onRowContextMenu:"",
         pageSize:9999,
         toolbar: [],
         onLoadSuccess: function(data) {
             $('#gridBaseMedDetail').datagrid("uncheckAll");  // onCheckAll onUncheckAll
             if(data.total>0){
                 $('#gridBaseMedDetail').datagrid("selectRow",0);
                 Com_Pid=data.rows[0].Pid;
             }
         },
         onCheck: function (row,rowdata) {
             Savetofitler(rowdata,"Y")
         },
         onUncheck: function (row,rowdata) {
             Savetofitler(rowdata,"N")
         },
         onCheckAll: function (data) {
             
           SavetofitlerAll(data,"Y")
         },
         onUncheckAll: function (data) {
           SavetofitlerAll(data,"N")
         }
         
     };
     PHA.Grid('gridBaseMedDetail', dataGridOption);
 }
 function Query(){
     KillTmp();
     $('#gridBaseMedLoc').datagrid('clear');
     $('#gridBaseMedTotal').datagrid('clear');
     $('#gridBaseMedDetail').datagrid('clear');
 
     var Params=GetParams();
     var pid="";
     var patNo = $("#conPatNo").val() || ""; 
     
     if(patNo==""){
         $("#gridBaseMedLoc").datagrid("query",{
             inputStr:Params,
             pid:pid
         }); 
     }else{
         var tab = $('#tabsOne').tabs('getSelected');
         var index = $('#tabsOne').tabs('getTabIndex',tab);
         if(index==0){
             $("#gridBaseMedTotal").datagrid("query",{
                 inputStr:Params,
                 pid:pid
             }); 
         }else if(index==1){
             $("#gridBaseMedDetail").datagrid("query",{
                 inputStr:Params,
                 pid:pid
             }); 
         }
     }
 
 }
 function GetParams(){
     var StDate =  $("#conPhStDate").datebox("getValue")|| ""; 
     var EdDate = $("#conPhEndDate").datebox("getValue") || ""; 
 
     var phLoc =  $("#conPhLoc").combobox("getValue")|| ""; 
     var patNo = $("#conPatNo").val() || ""; 
     var baseMedLocId = ""; 
     var Selected=$("#gridBaseMedLoc").datagrid("getSelected") || "";
     if(Selected!=""){
         baseMedLocId=Selected.LocRowId;
     } 
     
     var Params=StDate + "^" + EdDate  + "^" +phLoc  + "^" + patNo+ "^" +baseMedLocId;
     return Params;
 }
 
 function Clean(){
     KillTmp();
     var locDefVal = $("#conPhLoc").combobox("options").defVal || '';
     $("#conPhLoc").combobox("setValue", locDefVal);
     
     $('#conPhStDate').datebox('setValue', 't-1');
     $('#conPhEndDate').datebox('setValue', 't');
     $("#conPatNo").val('')
     $('#gridBaseMedLoc').datagrid('clear');
     $('#gridBaseMedTotal').datagrid('clear');
     $('#gridBaseMedDetail').datagrid('clear');
     
 }
 function KillTmp(){
     tkMakeServerCall("PHA.OP.BaseMedDisp.Query", "KillTmp", Com_Pid)
     
 }
 function SavetofitlerAll(Data,Flag){
     var baseMedLocId="";
     var Selected=$("#gridBaseMedLoc").datagrid("getSelected") || "";
     if(Selected!=""){
         baseMedLocId=Selected.LocRowId;
     } 
     var ret=tkMakeServerCall('PHA.OP.BaseMedDisp.OperTab', 'SaveToFitlerAll', Com_Pid, Flag,baseMedLocId);
     
 }
 function Savetofitler(rowData,Flag){
      var admId=rowData.AdmId;
      var PrescNo=rowData.PrescNo;
      var ret=tkMakeServerCall('PHA.OP.BaseMedDisp.OperTab', 'SaveToFitler', Com_Pid, admId, PrescNo,Flag);
 }
 function ConfirmFY()
 {
     var tab = $('#tabsOne').tabs('getSelected');
     var index = $('#tabsOne').tabs('getTabIndex',tab);
     var dateRows=0
     if(index==0){
         dateRows=$("#gridBaseMedTotal").datagrid("getRows");
          
     }else if(index==1){
         //dateRows=$("#gridBaseMedDetail").datagrid("getRows"); 
         var checkData=$("#gridBaseMedDetail").datagrid('getChecked');
         dateRows=checkData.length;
     }                   
     if(dateRows<=0){
         $.messager.alert("��ʾ", "û����Ҫ��ҩ�����ݣ�", 'info');
         return;
     }
     $.messager.confirm("��ҩ", "��ҩʱ���Ƿ����ɲ�����?", function (r) {
         if (r) {    
             ExecuteDispBaseMed();
             
         } else {
             ExecuteDisp()
         }
     });
 }
 function ExecuteDisp(){
     var phLoc =  $("#conPhLoc").combobox("getValue")|| ""; 
     PHA_OP.Progress.Show({ type: 'save', interval: 1000 });
     var RetInfo=$.cm({
         ClassName:'PHA.OP.BaseMedDisp.OperTab',
         MethodName:'SaveData',
         PhLocId:phLoc,
         Pid:Com_Pid,
         UserId:session['LOGON.USERID'],
         dataType:'text'
     },false);
     PHA_OP.Progress.Close();
     var retarr = RetInfo.split("$$");
     if(retarr.length==1){
         var errInfo=retarr[0];
         if(errInfo!=""){
             var errInfoArr = errInfo.split("^");
             var retval = errInfoArr[0];
             var retmessage= errInfoArr[1];
             if(retval!=""){
                 $.messager.alert("��ʾ", "��ҩʧ�ܣ�"+retmessage, 'error');
                 return;
             }
         }
 
     }else{
         var phdRowIdStr=retarr[1];
         /* //�Ƿ��ӡ�����ݶ�
         if(phdRowIdStr!=""){
             var phdRowIdArr=phdRowIdStr.split("^");
             var idLen=phdRowIdArr.length;
             for(var m=0;m<idLen;m++){
                 var phdRowId=phdRowIdArr[m];
                 
             }
         }*/
         var errInfo=retarr[0];
         if(errInfo!=""){
             var errInfoArr = errInfo.split("^");
             var retval = errInfoArr[0];
             var retmessage= errInfoArr[1];
             if(retval!=""){
                 $.messager.alert("��ʾ", "�������ݷ�ҩʧ�ܣ�"+retmessage, 'error');
                 return;
             }
         }
         KillTmp();
         Query();
     }
 
 }
 function ExecuteDispBaseMed()
 {
     var phLoc =  $("#conPhLoc").combobox("getValue")|| ""; 
     PHA_OP.Progress.Show({ type: 'save', interval: 1000 });
     var RetInfo=$.cm({
         ClassName:'PHA.OP.BaseMedDisp.OperTab',
         MethodName:'SaveSuppleData',
         PhLocId:phLoc,
         Pid:Com_Pid,
         UserId:session['LOGON.USERID'],
         dataType:'text'
     },false);
     PHA_OP.Progress.Close();
     var retarr = RetInfo.split("$$");
     if(retarr.length==1){
         var errInfo=retarr[0];
         if(errInfo!=""){
             var errInfoArr = errInfo.split("^");
             var retval = errInfoArr[0];
             var retmessage= errInfoArr[1];
             if(retval!=""){
                 $.messager.alert("��ʾ", "��ҩʧ�ܣ�"+retmessage, 'error');
                 return;
             }
         }
 
     }else{
         var suppRowIdStr=retarr[1];
         if(suppRowIdStr!=""){
             var suppRowIdArr=suppRowIdStr.split("^");
             var idLen=suppRowIdArr.length;
             for(var m=0;m<idLen;m++){
                 var suppRowId=suppRowIdArr[m];
                 OP_PRINTCOM.PrintSupply(suppRowId)
             }
             
         }
         var errInfo=retarr[0];
         if(errInfo!=""){
             var errInfoArr = errInfo.split("^");
             var retval = errInfoArr[0];
             var retmessage= errInfoArr[1];
             if(retval!=""){
                 $.messager.alert("��ʾ", "�������ݷ�ҩʧ�ܣ�"+retmessage, 'error');
                 return;
             }
         }
         KillTmp();
         Query();
     }
 
 }
 