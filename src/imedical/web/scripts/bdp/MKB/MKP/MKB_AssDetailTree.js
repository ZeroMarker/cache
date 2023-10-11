/*
名称: 医用知识库 -辅助功能区树型属性内容维护
描述: 包含增删改查功能
编写者: 基础数据平台组-石萧伟
编写日期: 2018-04-03
*/
var init = function(){  
	var HISUI_SQLTableName="MKB_TermProDetail"+property,HISUI_ClassTableName="User.MKBTermProDetail"+property;
	var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=DeleteData";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBTermProDetail";
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetJsonList";
	var PY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=SaveSearchWord";
	var QUERY_BYID_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetTreeJsonListById";
	//var property=1
	//获取扩展属性信息	
	var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
	var extend=extendInfo.split("[A]")
	var propertyName = extend[0];  //主列名
	var extendChild =extend[1];  //扩展属性child串
	var extendTitle =extend[2];  //扩展属性名串
	var extendType =extend[3];    //扩展属性格式串
	var extendConfig =extend[4];    //扩展属性配置项串
	
	var editIndex = undefined;  //正在编辑的行index
	var rowsvalue=undefined;   //正在编辑的行数据
	
	
	//treegrid列
	var columns =[[  
					{field:'id',title:'id',width:80,sortable:true,hidden:true},
					{field:'MKBTPDCode',title:'代码',width:80,sortable:true,hidden:true},
					{field:'MKBTPDLevel',title:'级别',width:80,sortable:true,hidden:true},
					{field:'MKBTPDDesc',title:propertyName,width:350,sortable:true,
						formatter: function(value, row, index) {
							var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
							return content;
						}  
					},
					{field:'MKBTPDRemark',title:'备注',width:200,sortable:true,
						formatter: function(value, row, index) {
							var content = '<span href="#" title="' + value + '" class="mytooltip">' + value + '</span>';
							return content;
						}  				
					},
					{field:'MKBTPDLastLevel',title:'上级分类',width:150,sortable:true,hidden:true},
					{field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true}
				]];
	
	 //如果有扩展属性，则自动生成列
	if (extendChild!="")  
	{
		var colsField = extendChild.split("[N]"); 
		var colsHead = extendTitle.split("[N]"); 
		var typeStr = extendType.split("[N]"); 
		var configStr = extendConfig.split("[N]"); 
		//alert(configStr)
		for (var i = 0; i <colsField.length; i++) {
			var labelName=colsHead[i];  //标题
			var comId='Extend'+colsField[i];   //控件id				
			var type=typeStr[i]   //类型
			var configInfos=configStr[i]  //配置项
			
			//添加列 方法1
			/*var record=[{
						 field:'Extend'+colsField[i],
						 title:colsHead[i],
						 width:150,
						 sortable:true
					}]
			columns[0].push(record[0])*/

			//添加列 方法2
			var column={};  
			column["title"]=labelName;  
			column["field"]=comId;  
			column["width"]=200;  
			column["sortable"]=true; 
			
			columns[0].push(column)
		
		}
	}
	
	//列表treegrid
	var mygrid = $HUI.treegrid("#mygrid",{
		url:QUERY_ACTION_URL+"&property="+property,
		columns:columns,
		idField: 'id',
		//ClassName: "web.DHCBL.MKB.MKBTermProDetail", //拖拽方法DragNode 存在的类 
		//DragMethodName:"DragNode",
		treeField:'MKBTPDDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
		autoSizeColumn:false,
		//ContextMenuButton:'sss',
		animate:false,     //是否树展开折叠的动画效果
		//rownumbers:true,    //设置为 true，则显示带有行号的列。
		//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true,	 
        onContextMenu:function (e, row) { //右键时触发事件
            e.preventDefault();//阻止浏览器捕获右键事件
            $(this).treegrid('select', row.id);
            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
            $(
            	'<div onclick="copyDetailBtn('+row.id+')" iconCls="icon-copyorder" data-options="">复制</div>'
            ).appendTo(mygridmm)
            mygridmm.menu()
            mygridmm.menu('show',{
                left:e.pageX,
                top:e.pageY
            });
        }		
	});
	//复制方法
	copyDetailBtn = function(detailid){
		//alert(termId)
		tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","copyIdToGloble","D",detailid);
	}	
}
$(init);
