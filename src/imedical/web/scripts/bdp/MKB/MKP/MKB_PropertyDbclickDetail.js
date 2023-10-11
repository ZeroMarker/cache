/**   
 * @Title: 测试Demo 
 * @Description:测试
 * @author: 程和贵
 * @Created:  2018-04-20
 */
var base=$.m({
        ClassName: "web.DHCBL.MKB.MKBTerm",
        MethodName: "GetBaseID",
        flag: "Diagnose"
    },false);
var precategory="";
var SAVE_ACTION_URL="../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=SaveData&pEntityName=web.Entity.MKB.MKBKnoManage";
var PREVIEW_FILE_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBKnoManage&pClassMethod=Webservice";
var Init=function() {
    //初始化grid
    GetList();
    //检索
    SearchData();
    //双击重置搜索框内容
    DbclearContent();
    //重置
    ResetData();
    //删除显示的分页下拉框
    DeletePage();
    PropertyGrid();
	var   copyToClipboard =function(elementId) {
        // 创建元素用于复制
        var aux = document.createElement("input");

        // 获取复制内容
        var content =elementId.text()||elementId.val() 

        // 设置元素内容
        aux.setAttribute("value", content);

        // 将元素插入页面进行调用
        document.body.appendChild(aux);

        // 复制内容
        aux.select();

        // 将内容复制到剪贴板
        document.execCommand("copy");

        // 删除创建元素
        document.body.removeChild(aux);

        //提示
        alert("复制内容成功：" + aux.value);
    }
	$(".datagrid-body").click(function(e){
		var $clicked=$(e.target);
		copyToClipboard($clicked);
	});
	$(".datagrid-view2").click(function(e){
		var $clicked=$(e.target);
		copyToClipboard($clicked);
	});
}
$(Init);

   
var GetList=function() {
    var columns = [[{
        field: 'MKBTDesc',
        title: '中心词',
        width: 100
    },{
        field: 'MKBTRowId',
        title: 'MKBTRowId',
        hidden:true
    }]];

    $("#listgrid").datagrid({
        url:$URL,   //QUERY_ACTION_URL
        queryParams: {
            ClassName: "web.DHCBL.MKB.MKBTerm",
            QueryName: "GetList",
            'base': base
        },
        width: '100%',
        height: '100%',
		scrollbarSize:8,
        toolbar: null,//上工具栏,空为null
        pagination: true,
        fitColumns: true,
        //loadMsg: '数据装载中......',
        autoRowHeight: true,
        singleSelect: true,
        pageSize:20,
        idField: 'MKBTRowId',
        fit: true,
        remoteSort: false,
        columns: columns,
        onLoadSuccess: function(data) {
            $("#listgrid").datagrid('selectRow',0);//默认选择第一条
        },
        onLoadError: function() {}
		
    });
    
}
var DeletePage=function(){
    //设置分页属性
    var mypagination = $('#listgrid').datagrid("getPager");
       if (mypagination){
           $(mypagination).pagination({
              showPageList:false,
              showRefresh:true
              // displayMsg: ""
           });
       }
}
var DbclearContent=function(){
    $(document).dblclick(function () {
        //$('#searchbox').searchbox('reset');作用同下
        $('#searchbox').searchbox('clear');
    });
}
var SearchData=function(){
        $('#searchbox').searchbox({
        searcher:function(value,name){
            $('#listgrid').datagrid('load', { 
                ClassName: "web.DHCBL.MKB.MKBTerm",
                QueryName: "GetList",
                'desc': value,
                'base':base
            });
        }
    });
    
}
var ResetData=function(){
    $("#btnReset").click(function (e) { 
        $('#listgrid').datagrid('load',  { 
            ClassName: "web.DHCBL.MKB.MKBTerm",
            QueryName: "GetList",
            'base':base
        });
        $('#searchbox').searchbox('setValue', null);        
    })  
}
var DetailList=function(proid){
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
    //获取扩展属性信息
    var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',proid);
    var extend=extendInfo.split("[A]")
    var propertyName = extend[0];  //主列名
    var extendChild =extend[1];  //扩展属性child串
    var extendTitle =extend[2];  //扩展属性名串
    var extendType =extend[3];    //扩展属性格式串
    var extendConfig =extend[4];    //扩展属性配置项串
    //datagrid列
    var columns =[[  
                    {field:'MKBTPDRowId',title:'RowId',width:80,sortable:true,hidden:true},
                    {field:'MKBTPDDesc',title:propertyName,width:150,sortable:true},
                    {field:'MKBTPDRemark',title:'备注',width:150,sortable:true},
                    {field:'MKBTPDSequence',title:'顺序',width:150,sortable:true,hidden:true,
                        sorter:function (a,b){  
                            if(a.length > b.length) return 1;
                                else if(a.length < b.length) return -1;
                                else if(a > b) return 1;
                                else return -1;
                        }
                    }
                ]];
    
    if (extendChild!="")   //如果有扩展属性，则自动生成列
    {
        var colsField = extendChild.split("[N]"); 
        var colsHead = extendTitle.split("[N]"); 
        var typeStr = extendType.split("[N]"); 
        var configStr = extendConfig.split("[N]"); 
        //alert(configStr)
        for (var i = 0; i <colsField.length; i++) {
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
            column["title"]=colsHead[i];  
            column["field"]='Extend'+colsField[i];  
            column["width"]=150;  
            column["sortable"]=true; 
            columns[0].push(column)

        }
    }
    
    //列表datagrid
    $("#"+proid).datagrid({
        url:QUERY_ACTION_URL+"&property="+proid,
        columns:columns,
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        //pageSize:25,
        //pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:false,
        idField:'MKBTPDRowId', 
        //rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        sortName : 'MKBTPDSequence',
        sortOrder : 'asc',
        ctrlSelect:true
    });
	
}

var PropertyGrid =function(){
	var collExpanflag=""
	var columnsProperty =[[
				  {field:'MKBTPRowId',title:'RowId',width:80,sortable:true,hidden:true},
				  {field:'MKBTPDesc',title:'属性名称',width:100,sortable:true},
				  {field:'MKBTPDDesc',title:'缩略语',width:160,sortable:true},
				  {field:'MKBTPFlag',title:'标识',width:80,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='S'){return '诊断展示名';}
						}},
				  {field:'MKBTPName',title:'主列名',width:100,sortable:true},
				  {field:'MKBTPType',title:'数据类型',width:80,sortable:true, 
					  formatter:function(v,row,index){  
							if(v=='TX'){return '文本';}
							if(v=='TA'){return '多行文本框';}
							if(v=='R'){return '单选框';}
							if(v=='CB'){return '复选框';}
							if(v=='C'){return '下拉框';}
							if(v=='L'){return '列表';}
							if(v=='T'){return '树形';}
							if(v=='S'){return '引用术语';}
							if(v=='P'){return '引用属性';}
							if(v=='SD'){return '引用属性内容';}
						}},
				  {field:'MKBTPConfig',title:'配置项',width:80,sortable:true,
					  formatter:function(value,rec){ 
					  		var columnConfig=rec.MKBTPConfig
					  		if (columnConfig.match("&%")>0){
					  			columnConfig=columnConfig.replace(/\&%/g,",")
					  		}else{
					  			columnConfig=rec.MKBTPConfig
					  		}
					  		return columnConfig;
					  	}
				  	},
				  {field:'MKBTPDefinedNode',title:'起始节点',width:80,sortable:true,hidden:true},
				  {field:'MKBTPPublic',title:'共有/私有',width:80,sortable:true,
					  formatter:function(v,row,index){  
							if(v=='Y'){return '公有';}
							else{return '私有';}
						}},
				  {field:'MKBTPSequence',title:'顺序',width:80,sortable:true,hidden:true,
					  sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;
						}}
				  ]];
	var mygridProperty = $HUI.datagrid("#mygridProperty",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.MKB.MKBTermProperty",
			QueryName:"GetList"
		},
		columns: columnsProperty,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:10,
		nowrap:false,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MKBTPRowId', 
		rownumbers:false,    //设置为 true，则显示带有行号的列。
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		scrollbarSize :0,
		autoRowHeight:true, 
		sortName:'MKBTPSequence',
		sortOrder:'asc',
		view: detailview,
		detailFormatter: function(rowIndex, rowData){
				return "<div style='width:100%;height:300px'><table data-options='fit:true,border:false' id='"+rowData.MKBTPRowId+"'></table></div>";
						/*'<td rowspan=2 style="border:0"><b>hello world</b></td>' +
						'<td style="border:0">' +
						'<p>Attribute: ' + rowData.MKBTPRowId + '</p>' +
						'<p>Status: ' + rowData.MKBTPDesc + '</p>' +
						'<p>Status: ' + rowData.MKBTPType + '</p>' +
						'</td>' +
						'</tr></table>';*/
					},
		onExpandRow:function(index,row){
			DetailList(row.MKBTPRowId);
		},
		onDblClickRow:function(index,row){
			if(collExpanflag=="colla")
			{
				$("#mygridProperty").datagrid('expandRow',index);
				collExpanflag="expan"
			}else{
				$("#mygridProperty").datagrid('collapseRow',index);
					collExpanflag="colla"
			}
			//$(this).parent().after("<tr><td>hello</td></tr>");
		}
		
	})
	$("#listgrid").datagrid({
		onSelect:function(index,row){
				var termdr =row.MKBTRowId;
			    $('#mygridProperty').datagrid('load',{ 
				ClassName:"web.DHCBL.MKB.MKBTermProperty",
				QueryName:"GetList",
				termdr: termdr	
			});
			
		}
	})

}