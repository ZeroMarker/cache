/*
Creator:石萧伟
CreatDate:2017-04-02
Description:医用知识库-诊断辅助功能区
*/
var flagInfo=flag
var baseInfo=base
var strInfo=str
var matchflag=matchflag
var basetype= tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID",baseInfo)
//判断是被哪个搜索按钮调用
if(flagInfo=="Y"||flagInfo=="MaxY")
{
    /*var className="web.DHCBL.MKB.MKBAssInterface";
	var queryName="GetTerm";*/
	var ASS_FOR_LIST="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetNewTerm&base="+base+"&str="+encodeURI(strInfo);    
    //树形参数
    //var tClassName="web.DHCBL.MKB.MKBAssInterface";
    //var tClassMethod="GetTreeTerm";
	//basetype="L";
	var ASS_FOR_TREE="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTreeTerm&base="+base+"&str="+encodeURI(strInfo);    
}
else if(flagInfo=="N"||flagInfo=="MaxN")
{
    /*var className="web.DHCBL.MKB.MKBTerm"
	var queryName="GetAssList"*/
	var ASS_FOR_LIST="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBTerm&pClassMethod=GetMyList&base="+baseInfo+"&sortway="+parent.sortway+"&closeflag="+parent.closeflag+"&desc="+encodeURI(strInfo)+"&matchflag="+matchflag;   

    //树形参数
    //var tClassName="web.DHCBL.MKB.MKBTerm";
    //var tClassMethod="GetTreeJson";
    basetype= tkMakeServerCall("web.DHCBL.MKB.MKBTerm", "GetBaseTypeByID",baseInfo)
    var ASS_FOR_TREE="../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBAssInterface&pClassMethod=GetTreeJson&base="+base;  
}
var init = function(){
    //双击数据后，生成足迹超链接
    clickrow=function(rowData)
    {
	    if(flagInfo=="N"||flagInfo=="Y")
	    {
			var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+rowData.MKBTRowId;
	        //双击数据跳转到属性界面
	        parent.$('#myiframe').attr("src",url);
	        if(basetype=="L")
	        {
		        var desc=rowData.MKBTDesc.substr(0,6);
		    }
	        else
	        {
		        var desc=rowData.MKBTDesc.substr(0,6);
		    }
	        parent.$('#footTwo').text(desc+"...");
	        parent.$('#diaId').text(rowData.MKBTRowId);
	        parent.$('#arrow1').show();
		}
		else if(flagInfo=="MaxY"||flagInfo=="MaxN")
		{   var flagP="Y"
			var url="../csp/dhc.bdp.mkb.mkbassproperty.csp"+"?diaId="+rowData.MKBTRowId+"&flagP="+flagP;
	        //双击数据跳转到属性界面
	        parent.$('#Maxiframe').attr("src",url);
	        //var desc=rowData.MKBTDesc.substr(0,6);
	        if(basetype=="L")
	        {
		       parent.$('#winfoot2').text(rowData.MKBTDesc); 
		    }
	        else
	        {
		        parent.$('#winfoot2').text(rowData.MKBTDesc); 
		    }
	        parent.$('#diaId').text(rowData.MKBTRowId);
	        parent.$('#arrowMax1').show();
		}
    }
	if(basetype=="L")
	{
	    //中心词界面
	    var termcolumns =[[
	        {field:'MKBTRowId',title:'MKBTRowId',width:80,hidden:true},
	        {field:'MKBTDesc',title:'中心词',width:130
	        	/*formatter:function(value,row,index){
		        	//return row.MKBTRowId;	
		        	var flag = tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","justTermExist",row.MKBTRowId);
		        	if(flag == 1){
						 var content = '<font color=red>' + value + '</font>';
						 return content;	
			        }
			        else{
				        var content = '<font color=green>' + value + '</font>';
				    	return content;
				    }
		        }*/
	        },
	        {field:'MKBTSequence',title:'MKBTSequence',width:150,hidden:true,sorter:function (a,b){  
						    if(a.length > b.length) return 1;
						        else if(a.length < b.length) return -1;
						        else if(a > b) return 1;
						        else return -1;}}
	    ]];
	    var termgrid = $HUI.datagrid("#termgrid",{
	        url:ASS_FOR_LIST,
	        /*queryParams:{
	            ClassName:className,
	            MethodName:queryName,
	            base:baseInfo,
	            str:strInfo
	        },*/
	        width:'100%',
	        height:'100%',
	        //url:TERM_ACTION_URL,
	        columns: termcolumns,  //列信息
	        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
	        pageSize:10,
	        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
	        sortName:'MKBTSequence',
	        sortOrder:'asc',
	        remoteSort:false,  //定义是否从服务器排序数据。true
	        singleSelect:true,
	        idField:'MKBTRowId',
	        rownumbers:false,    //设置为 true，则显示带有行号的列。
	        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
	        fit:true,
	        //remoteSort:false,  //定义是否从服务器排序数据。true
	        scrollbarSize :0,
	        onDblClickRow:function(rowIndex,rowData){
	            clickrow(rowData);
	        },
	        onLoadSuccess:function(data){
				$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

	        },
	        onClickRow:function(index,row)
	        {
	        	var rowdata = tkMakeServerCall("web.DHCBL.MKB.MKBTerm","OpenData",row.MKBTRowId)
                	var rowdata=eval('('+rowdata+')');
	        	parent.IsShowImg(rowdata)
	         	parent.$("#TextSearchProperty").combobox('setValue', ''); 
	        	parent.InitmygridProperty(row.MKBTRowId,"")
	        	RefreshSearchData("User.MKBTerm"+baseInfo,row.MKBTRowId,"A",row.MKBTDesc);
	        },
	        onCheck:function(index,row)
	        {
		    }		
	    });
    }
    else if(basetype=="T")
    {
		var columns =[[  
					  {field:'MKBTRowId',title:'MKBTRowId',width:80,sortable:true,hidden:true},
					  {field:'MKBTDesc',title:'中心词',width:300,sortable:true},
					  //{field:'MKBTSequence',title:'顺序',width:150,sortable:true,hidden:true },
					  //{field:'MKBTLastLevel',title:'上级节点',width:80,hidden:true}
					  ]];
		var mygrid = $HUI.treegrid("#termgrid",{
			url:ASS_FOR_TREE,
			ClassTableName:'User.MKBTerm',
			SQLTableName:'MKB_Term',
			columns: columns,  //列信息
			//height:$(window).height()-105,   ///需要设置高度，不然数据展开太多时，列头就滚动上去了。
			idField: 'MKBTRowId',
			treeField:'MKBTDesc',  //树形列表必须定义 'treeField' 属性，指明哪个字段作为树节点。
			//autoSizeColumn:false,
			fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			animate:false,     //是否树展开折叠的动画效果
			//fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
			remoteSort:false,  //定义是否从服务器排序数据。true
	        onDblClickRow:function(rowIndex,rowData){
	            clickrow(rowData);
	            //alert(rowData.ID);
	        },
	        onClickRow:function(index,row)
	        {
	        	RefreshSearchData("User.MKBTerm"+baseInfo,row.MKBTRowId,"A",row.MKBTDesc);
	        },	        
	        onLoadSuccess:function(data){
				$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
	        },	 
	        onContextMenu:function (e, row) { //右键时触发事件
	            e.preventDefault();//阻止浏览器捕获右键事件
	            $(this).treegrid('select', row.MKBTRowId);
	            var mygridmm = $('<div style="width:120px;"></div>').appendTo('body');
	            $(
                	'<div onclick="copyTermBtn('+row.MKBTRowId+')" iconCls="icon-copyorder" data-options="">复制</div>'
	            ).appendTo(mygridmm)
	            mygridmm.menu()
	            mygridmm.menu('show',{
	                left:e.pageX,
	                top:e.pageY
	            });
	        }				
		})
		if(flagInfo=="N"||flagInfo=="MaxN")
		{
			setTimeout(function(){
				$("#termgrid").treegrid("search", strInfo);
			},500) 
		}

		//复制方法
		copyTermBtn = function(termId){
			//alert(termId)
			tkMakeServerCall("web.DHCBL.MKB.MKBAssInterface","copyIdToGloble","T",termId);
		}		 
	} 
}
$(init);