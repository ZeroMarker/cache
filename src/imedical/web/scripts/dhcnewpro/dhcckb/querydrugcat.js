/**
  *qunianpeng 
  *2020-09-14
  *�����ѯ 
  *
 **/

var catType = "";
var ruleUse = "";
var hospID = "";
var catTypeArr =[{value:"all",text:"ȫ������"},{value:"other",text:"��������"},{value:"five",text:"�±�ҩ��ѧ����"},{value:"notin",text:"���������±�ҩ��ѧ����"}]
/// ҳ���ʼ������
function initPageDefault(){

	InitCombobox();		/// ��ʼ��combobox
	
	InitBlButton(); 	/// ҳ�� Button ���¼�

	InitDataGrid();		/// ��ʼ��DataGrid
}

/// ��ʼ��combobox
function InitCombobox(){
	
	 $HUI.combobox("#catType",{
	     valueField:'value',
						textField:'text',
						data:catTypeArr,
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								catType = option.value;
						}
	   });
	   
	   // Ժ��
    var uniturl = $URL+"?ClassName=web.DHCCKBCommonUtil&MethodName=QueryHospList"  
    $HUI.combobox("#hospId",{
	     url:uniturl,
	     valueField:'value',
						textField:'text',
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								hospID = option.value;
						}
	   })
	   
	   // ��������
	   $HUI.combobox("#ruleUse",{
	     valueField:'value',
						textField:'text',
						data:[
							{value:"Y",text:"��"},
							{value:"N",text:"��"}
						],
						panelHeight:"150",
						mode:'remote',
						onSelect:function(option){
								ruleUse = option.value;
						}
	   });

}

/// ҳ�� Button ���¼�
function InitBlButton(){
	
	///  ��ѯ
	$('#search').bind("click",SearchData);	
	
	/// 	����
	$('#reset').bind("click",RefreshData);
	
	//�س��¼���
	$('#queryText').bind("keyup",function(event){
		if(event.keyCode == "13"){
			SearchData();
		}
	});
}

/// ��ʼ��DataGrid
function InitDataGrid(){
	
	//��ʼ��HIS��
	/**
	 * ����HIS���columns
	 */
	var hiscolumns=[[
		{field:'f1',title:'1��',width:250,sortable:true},
	 {field:'f2',title:'2��',width:250,sortable:true},
	 {field:'f3',title:'3��',width:250,sortable:true},  
	 {field:'f4',title:'4��',width:250,sortable:true},  
		{field:'f5',title:'5��',width:250,sortable:true},  
		{field:'f6',title:'6��',width:250,sortable:true},  
		{field:'f7',title:'7��',width:150,sortable:true},  
		{field:'f8',title:'8��',width:150,sortable:true},  
		{field:'f9',title:'9��',width:150,sortable:true},  
		{field:'f10',title:'10��',width:150,sortable:true}
	]];
	
	/**
	 * ����HIS���datagrid
	 */
		var hisGrid = $HUI.datagrid("#catlist",{
								//toolbar:'#toolbar',
        url:$URL,
        queryParams:{
	        ClassName:"web.DHCCKBComExportUtil", 	// qunianpeng �滻�� 2020/3/29
         QueryName:"ExportDrugCat",
         catType:catType,
        	hospID:hospID,
        	ruleUse:ruleUse,
        	input:$("#queryText").val()
	    },
	    columns: hiscolumns,  //����Ϣ
	    pagination: true,   //pagination	boolean	����Ϊ true��������������datagrid���ײ���ʾ��ҳ��������
	    pageSize:20,
	    pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	    remoteSort:false,
	    //idField:'RowId',
	    singleSelect:true,
	    rownumbers:true,    //����Ϊ true������ʾ�����кŵ��С�
	    fitColumns:true, //����Ϊ true������Զ��������С�еĳߴ�����Ӧ����Ŀ�Ȳ��ҷ�ֹˮƽ����
	    onClickRow:function(index,row) {   	
	    },	
	    onLoadSuccess:function(data){
						//	$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
	    },
	     onBeforeLoad: function (param) {
         /*    var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true; */
        }	   
   });
   $('#catlist').datagrid('loadData',{total:0,rows:[]});  // �ÿ��������datagrid
}

/// ��ѯ����
function SearchData(){
 
	$('#catlist').datagrid('load',  {
   ClassName:"web.DHCCKBComExportUtil", 
   QueryName:"ExportDrugCat",
   catType:catType,
  	hospID:hospID,
  	ruleUse:ruleUse,
  	input:$("#queryText").val()
  });
	$('#catlist').datagrid('unselectAll');  // ����б�ѡ������ 
}

/// �������
function RefreshData(){
	
		$HUI.combobox("#catType").setValue("");
		$HUI.combobox("#hospId").setValue("");
		$HUI.combobox("#ruleUse").setValue("");
		catType ="";
		hospID = "";
		ruleUse = "";
		$("#queryText").val("");
		SearchData();
	}

/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })