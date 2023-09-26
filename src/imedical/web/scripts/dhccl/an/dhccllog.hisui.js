var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
$(function(){

    initConditionFormControls();
    initOperationGrid();
    
});

//��ʼ�����ؼ�
function initConditionFormControls(){
	$HUI.datebox("#dateFrm",{})
	$HUI.datebox("#dateTo",{})
    var logvalue=$HUI.combobox("#LogValue",{
        url:$URL+"?ClassName=web.DHCCLLog&QueryName=LookupCLCLog&ResultSetType=array",
        valueField:"tClclogId",
        textField:"tClclogDesc",
        onBeforeLoad:function(param)
        {
            
        }
        ,onSelect:function()
        {
	        $("#OriginValue").combobox("reload");
	        $("#EditValue").combobox("reload");
        }
    });	
    

    var originValue=$HUI.combobox("#OriginValue",{
        url:$URL+"?ClassName=web.DHCCLLog&QueryName=LookupCLCLogValue&ResultSetType=array",
        valueField:"tValue",
        textField:"tValueDesc",
        onBeforeLoad:function(param)
        {
            param.clclogId=$("#LogValue").combobox('getValue');
        },
        mode:'remote'
    });
    var editValue=$HUI.combobox("#EditValue",{
        url:$URL+"?ClassName=web.DHCCLLog&QueryName=LookupCLCLogValue&ResultSetType=array",
        valueField:"tValue",
        textField:"tValueDesc",
        onBeforeLoad:function(param)
        {
            param.clclogId=$("#LogValue").combobox('getValue');
        },
        mode:'remote'
    });

    var dateFrom=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDate",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
        var dateTo=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetInitialDateOld",
        userId:logUserId,
        userGroupId:"", 
        ctlocId:logLocId
    },false);
    $("#dateFrm").datebox('setValue',dateFrom);
    $("#dateTo").datebox('setValue',dateTo);

    $("#btnSearch").click(function(){
	      				$('#LogList').datagrid({
					queryParams: {
						ClassName: "web.DHCCLLog",
						QueryName: "FindCLLog",
					},
					onBeforeLoad:function(param)
        			{
            		param.fromDate=$("#dateFrm").datebox('getValue');
            		param.toDate=$("#dateTo").datebox('getValue');
            		param.clclogId=$("#LogValue").combobox('getValue');
            		param.logRecordId='';
            		param.tcpip=$("#UserIp").val();
            		param.preValue=$("#OriginValue").combobox('getValue');
            		param.postValue=$("#EditValue").combobox('getValue');

        			}
				})
        //$HUI.datagrid("#LogList").load();
    }); 
    
}
//��ʼ�������б�
function initOperationGrid(){
    
    var LogList=$HUI.datagrid("#LogList",{
        fit:true,
        rownumbers: true,
        pagination: true,
        pageSize: 50,
        pageList: [50, 100, 200],
        checkbox: true,
        headerCls:'panel-header-gray',
        url:$URL,
        queryParams:{
            ClassName:"web.DHCCLLog",
            QueryName:"FindCLLog"
        },
        onBeforeLoad:function(param)
        {
            param.fromDate=$("#dateFrm").datebox('getValue');
            param.toDate=$("#dateTo").datebox('getValue');
            param.clclogId=$("#LogValue").combobox('getValue');
            param.logRecordId='';
            param.tcpip=$("#UserIp").val();
            param.preValue=$("#OriginValue").combobox('getValue');
            param.postValue=$("#EditValue").combobox('getValue');
        },
        onClickRow: function(rowIndex, rowData) {
		},
        columns: [
            [
                { field: "tClclogDesc", title: "��־��Ŀ", width: 100 },
                { field: "tLogRecordId", title: "��¼Id", width: 60 },
                { field: "tPreValue", title: "��ǰֵ", width: 60 },
                { field: "tPreNote", title: "��ǰ˵��", width: 60 },
                { field: "tPostValue", title: "�ĺ�ֵ", width: 100 },
                { field: "tPostNote", title: "�ĺ�˵��", width: 105 },
                { field: "tUpdateUser", title: "�����û�", width: 70 },
                { field: "tMedCareNo", title: "������", width: 80 },
                { field: "tPatname", title: "��������", width: 100 },
                { field: "tUpdateTcpip", title: "IP��ַ", width: 120 },
                { field: "tLocdes", title: "����", width: 65 },
                { field: "tOPDOC", title: "����ҽ��", width: 60 },
                { field: "tOpRoom", title: "������", width: 80 },
                { field: "tOpaSeq", title: "̨��", width: 100 },
                { field: "topdate", title: "����ʱ��", width: 120 },
                { field: "tCllogIfReceive", title: "tCllogIfReceive", width: 100 },
                { field: "tPostQT", title: "tPostQT", width: 60 },
                { field: "tPostYY", title: "tPostYY", width: 60 },
                { field: "tUpdateDate", title: "��������", width: 120 },
                { field: "tUpdateTime", title: "����ʱ��", width: 60 },
              	{ field: "tCllogId", title: "tCllogId", width: 80 },
                { field: "tClclogId", title: "tClclogId", width: 80 },
               { field: "opStat", title: "����״̬", width: 60 }
             
            ]                
        ],
        onSelect:function(index,data){
            //$("#patient-toolbar").find(".content").html(data.patname+" / "+data.gender+" / "+data.age+" / "+data.regno);
        },
		handler:function(){ //���ܸı��ֵ
        //$("#OperListBox").datagrid('acceptChanges');
        },
		onBeforeEdit:function(rowIndex,rowData){
			
		}
    });
}	
