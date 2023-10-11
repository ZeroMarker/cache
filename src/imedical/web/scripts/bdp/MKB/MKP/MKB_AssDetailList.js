/*
名称: 医用知识库 -辅助功能区列表型属性内容维护
描述: 包含增删改查功能
编写者: 基础数据平台组-石萧伟
编写日期: 2018-04-03
*/
var property=property
var propertyName=propertyName
var init = function(){

    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTermProDetail&pClassMethod=GetMyList";
    //var property=1
    //获取扩展属性信息
   var extendInfo=tkMakeServerCall('web.DHCBL.MKB.MKBTermProDetail','getExtendInfo',property);
    var extend=extendInfo.split("[A]")
    var propertyName = extend[0];  //主列名
    var extendChild =extend[1];  //扩展属性child串
    var extendTitle =extend[2];  //扩展属性名串
    var extendType =extend[3];    //扩展属性格式串
    var extendConfig =extend[4];    //扩展属性配置项串
    //datagrid列
    var columns =[[  
                    {field:'MKBTPDRowId',title:'RowId',width:80,sortable:true,hidden:true},
                    {field:'MKBTPDDesc',title:propertyName,width:200,sortable:true},
                    {field:'MKBTPDRemark',title:'备注',width:250,sortable:true},
                    {field:'MKBTPDSequence',title:'顺序',width:250,sortable:true,hidden:true,
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
    var mygrid = $HUI.datagrid("#mygrid",{
        url:QUERY_ACTION_URL+"&property="+property,
        columns:columns,
        pagination: true,   //pagination    boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
        singleSelect:false,
        idField:'MKBTPDRowId', 
        toolbar:'#mytbar',
        rownumbers:false,    //设置为 true，则显示带有行号的列。
        fitColumns:false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        remoteSort:false,  //定义是否从服务器排序数据。true
        sortName : 'MKBTPDSequence',
        sortOrder : 'asc',
        scrollbarSize :0,
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

        }
        
    });
}
$(init);

