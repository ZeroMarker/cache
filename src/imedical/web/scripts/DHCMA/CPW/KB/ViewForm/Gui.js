//ҳ��Gui
var obj = new Object();
function InitViewFromWin(){	
    var viewColumns = [];			//���������
    
    $cm({
		ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
		QueryName:"QryPathStage",
		aPathBaseDr:PathFormID,
		ResultSetType:"array",
	},function(rs){
		//��̬����б���
		console.log(rs)
		for (var i=0;i<rs.length;i++){
			var tmpObj = rs[i];
			viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc}
		}		
		$cm({
			ClassName:"DHCMA.CPW.KBS.PathBaseSrv",
			MethodName:"GetViewFormItems",
			aPathBaseID:PathFormID
		},function(rs){
			//debugger
			//��ȡ����ͼ
			obj.gridViewForm = $HUI.datagrid("#gridViewForm",{
				fit: true,
				title:'·�����ƣ�<span style=\"color:#1584D2\"><b>'+rs.name+'<b/></span>',
				headerCls:'panel-header-gray', //������ʹ����ɻ�ɫ
				pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
				rownumbers: false, //���Ϊtrue, ����ʾһ���к���
				singleSelect: false,
				autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
				loadMsg:'���ݼ�����...',
				pageSize: 99,
				pageList : [20,50,100,200],
				data:rs,
			    frozenColumns: [[
		        	{ field: 'step', title: '����', width: 100,styler: function (value, row, index) {
             			return 'background-color:#F4F6F5;';
          			}},
		        ]],
				columns:[viewColumns],
				onBeforeLoad: function (param) {
		            var firstLoad = $(this).attr("firstLoad");
		            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
		            {
		                $(this).attr("firstLoad","true");
		                return false;
		            }
		            return true;
				},
				onLoadSuccess:function(){
					$(this).prev().find('div.datagrid-body').unbind('mouseover');
					$(":input").attr("disabled", "disabled");     
					$.parser.parse();	
				},
				onClickRow: function (rowIndex, rowData) {
    				$(this).datagrid('unselectRow', rowIndex);
				}
				,
				rowStyler: function(index,row){
					return 'background-color:#F7FBFF;';
				}
			});
		})
	})
	
	//$.parser.parse();
	InitViewFormWinEvent(obj);
	obj.LoadEvents(arguments);
}