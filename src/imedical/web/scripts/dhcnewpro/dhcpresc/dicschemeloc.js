/// author:    huanghongping
/// date:      2021-07-20
/// descript:  ��Ա��Ϣ�ֵ�ά��

var editRow = ""; editDRow = ""; editPRow = "";
/// ҳ���ʼ������
function initPageDefault() {

    //��ʼ����Ա��Ϣ����
    InitMainList();




}



///��ʼ���ֵ������б�
function InitMainList() {

	/**
	 * �ı��༭��
	 */
    var textEditor = {
        type: 'text',//���ñ༭��ʽ
        options: {
            required: true, //���ñ༭��������
            editable: false
        }
    }

	/**
	 * ����columns
	 */
    var columns = [[
        { field: 'checkbox', checkbox: true },
        { field: 'RowId', title: 'ID', hidden: true, align: 'center' },
        { field: 'HosDesc', title: '��������', align: 'center' },
        { field: 'LoginId', title: '��¼��', align: 'center' },
        { field: 'LoginName', title: '�û�����', hidden: false, align: 'center' },
        { field: 'CtStr', title: '������', align: 'center' },
    ]];

	/**
	 * ����datagrid
	 */
    var option = {
        title: 'ҩʦ�б�',
        //nowrap:false,
        headerCls: 'panel-header-gray',
        rownumbers: true,
        singleSelect: false,
        iconCls: 'icon-paper',
        fitColumns: true,
        onDblClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭

        },
        onClickRow: function (rowIndex, rowData) {

        }
    };

    var uniturl = $URL + "?ClassName=web.DHCPRESCDicScheme&QueryName=GetAllPLCtLoc&SearchString=";
    new ListComponent('main', columns, uniturl, option).Init();
}



/// JQuery ��ʼ��ҳ��
$(function () {
    initPageDefault();

    /// ���� 
    $("#ManageSearch").click(function () {
        //	    var startDate=$("#Code").datebox('getValue')
        //	    var endDate=$("#Name").datebox('getValue')
        //	    var sort = $("#switch").switchbox('getValue') 
        var SearchString = $("#Code").val()
        $("#main").datagrid('load', { SearchString: SearchString })
    });

    $("#echarts").click(function () {
        var datas = $("#main").datagrid("getSelections");
        var datasArry = []
        for (i in datas) {
            var tempData = datas[i].RowId
            datasArry.push(tempData)
        }

        if(datas.length<1){
	      $.messager.confirm("��ʾ","δѡ��ҩʦ����Ĭ��Ϊ��¼���Լ�ѡ����ң��Ƿ������",function(e){
		      if(e==true){
			      OpenConsWin();
			      var url = "dhcpresc.dicscheme.csp?datas="+datasArry;
			      if ('undefined'!==typeof websys_getMWToken){
					url += "&MWToken="+websys_getMWToken();
				  }
	      		  $("#newWinFrame").attr("src",url);
			      
			  }
			  else{
				  return;  
			  }    
		      
		  } );	    
	      }
		  else{
			  OpenConsWin();
			  var url = "dhcpresc.dicscheme.csp?datas="+datasArry;
			  if ('undefined'!==typeof websys_getMWToken){
				url += "&MWToken="+websys_getMWToken();
			  }
	      	  $("#newWinFrame").attr("src",url);
			  
		 }	
		  
	      
})
      

    /// ��MDT��дҳ��
    function OpenConsWin() {
        var option = {
            collapsible: false,
            minimizable: false,
            maximizable: false,
            border: true,
            closed: "true",
            iconCls: 'icon-w-card',
            onBeforeClose: function () {
                $("#main").datagrid('reload')
            }

        };
        new WindowUX('���ҷ���', 'ConsWin', '1250', '500', option).Init();
    }

    $("#tempLink").click(function () {
        var url = "dhcpresc.loctemp.csp";
        websys_createWindow(url, true, "status=1,scrollbars=1,top=0,left=0,width=1200,height=700");

    })
})


