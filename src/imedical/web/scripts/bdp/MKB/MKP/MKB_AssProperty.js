/*
Creator:石萧伟
CreatDate:2017-04-02
Description:医用知识库-诊断辅助功能区
*/
var diaId=diaId
var flagInfo=flagP
var init = function(){
    //双击数据后，生成足迹超链接
    clickrow=function(rowData)
    {
	    if(flagInfo=="Y")
	    {
	        parent.$('#footLarge').append("<td id='arrowMax2'></td><td id='winfoot3'>"+rowData.MKBTPDesc+"</td>");
	        //alert(rowData.TKBTEType);
	        //点击超链接返回
	        if(rowData.MKBTPType=="L")
	        {
	            //双击数据跳转到内容界面（列表型）
	            var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#Maxiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="T")
	        {
	            //列表型
	            var url="../csp/dhc.bdp.mkb.mkbassdetailtree.csp"+"?property="+rowData.MKBTPRowId;
	            parent.$('#Maxiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="F")
	        {
	            //文本型
	            var url="../csp/dhc.bdp.mkb.mkbassdetailtext.csp"+"?property="+rowData.MKBTPRowId;
	            parent.$('#Maxiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="P")
	        {
	            //引用属性格式属性内容维护模块
	            var url="../csp/dhc.bdp.mkb.mkbassdetailproperty.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#Maxiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="S")
	        {
	            //引用术语格式属性内容维护模块
	           //var url="../csp/dhc.bdp.mkb.mkbassdetailterm.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	           //parent.$('#Maxiframe').attr("src",url);
	           	var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",rowData.MKBTPRowId)  //引用术语是树形还是列表型
            	if(configListOrTree=="T")
				{
					url="dhc.bdp.mkb.mkbassdetailtreeterm.csp?property="+rowData.MKBTPRowId
				}
				else
				{
					url="dhc.bdp.mkb.mkbassdetaillistterm.csp?property="+rowData.MKBTPRowId
				}
	            parent.$('#Maxiframe').attr("src",url);
			}
			else if(rowData.MKBTPType=="SS")
			{
	            //引用起始节点
	            var url="../csp/dhc.bdp.mkb.mkbtermprodetailsingleterm.csp"+"?property="+rowData.MKBTPRowId;
	            parent.$('#Maxiframe').attr("src",url);				
			}
	        else
	        {
	            parent.$('#arrowMax2').remove();
	            parent.$('#winfoot3').remove();
	            //var url= "../csp/dhc.bdp.mkb.mkbassdetailothers.csp"+"?property="+rowData.MKBTPRowId;
	            //parent.$('#Maxiframe').attr("src",url);
	          
	        }
	           parent.$('#Maxiframe').attr("src",url);
	           //parent.$('#diaId3').text(rowData.MKBTPRowId);

		}
		else
		{
			if(rowData.MKBTPDesc.length<=5)
	        {
	             parent.$('#foot').append("<td id='arrow2'>></td><td id='footThree'>"+rowData.MKBTPDesc+"</td>");
	        }
	        else
	        {
	             var desc=rowData.MKBTPDesc.substr(0,4);
	             parent.$('#foot').append("<td id='arrow2'>></td><td id='footThree'>"+desc+"...</td>");
	        }

	        //alert(rowData.TKBTEType);
	        //点击超链接返回
	        if(rowData.MKBTPType=="L")
	        {
	            //双击数据跳转到内容界面（列表型）
	            var url="../csp/dhc.bdp.mkb.mkbassdetaillist.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#myiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="T")
	        {
	            //树形
	            var url="../csp/dhc.bdp.mkb.mkbassdetailtree.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#myiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="F")
	        {
	            //文本型
	            var url="../csp/dhc.bdp.mkb.mkbassdetailtext.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#myiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="P")
	        {
	            //引用属性格式属性内容维护模块
	            var url="../csp/dhc.bdp.mkb.mkbassdetailproperty.csp"+"?property="+rowData.MKBTPRowId+"&propertyName="+rowData.MKBTPDesc;
	            parent.$('#myiframe').attr("src",url);
	        }
	        else if(rowData.MKBTPType=="S")
	        {
	            //引用术语格式属性内容维护模块
	            var configListOrTree = tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetProListOrTree",rowData.MKBTPRowId)  //引用术语是树形还是列表型
            	if(configListOrTree=="T")
				{
					url="dhc.bdp.mkb.mkbassdetailtreeterm.csp?property="+rowData.MKBTPRowId
				}
				else
				{
					url="dhc.bdp.mkb.mkbassdetaillistterm.csp?property="+rowData.MKBTPRowId
				}
	            parent.$('#myiframe').attr("src",url);
			}
			else if(rowData.MKBTPType == "SS")
			{
				//引用起始节点
	            var url="../csp/dhc.bdp.mkb.mkbtermprodetailsingleterm.csp"+"?property="+rowData.MKBTPRowId;
	            parent.$('#myiframe').attr("src",url);
			}
	        else
	        {
	            parent.$('#arrow2').remove();
	            parent.$('#footThree').remove();
	            //var url= "../csp/dhc.bdp.mkb.mkbassdetailothers.csp"+"?property="+rowData.MKBTPRowId;
	            //parent.$('#myiframe').attr("src",url);
	        }
	           //parent.$('#myiframe').attr("src",url);
	           parent.$('#diaId3').text(rowData.MKBTPRowId);
	    }
	}
    //属性界面数据
    var columns =[[
        {field:'MKBTPRowId',title:'MKBTPRowId',width:80,sortable:true,hidden:true},
        {field:'MKBTPDesc',title:'属性名称',width:150,sortable:true},
        {field:'MKBTPDDesc',title:'缩略语',width:150,sortable:true},
        {field:'MKBTPType',title:'类型',width:150,sortable:true,hidden:true},
	  	{field:'MKBTPSequence',title:'顺序',width:80,sortable:true,hidden:true/*,
  			sorter:function (a,b){  
	    	if(a.length > b.length) return 1;
	       	 	else if(a.length < b.length) return -1;
	        	else if(a > b) return 1;
	        	else return -1;
		}*/}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.MKB.MKBTermProperty",
            QueryName:"GetList",
            termdr:diaId
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        idField:'MKBTPRowId',
        rownumbers:false,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        sortName:'MKBTPSequence',
        sortOrder:'asc',
        remoteSort:true,  //定义是否从服务器排序数据。true
        scrollbarSize :0,
        onDblClickRow:function(rowIndex,rowData){
            clickrow(rowData);
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);

        }
    });


}
$(init);