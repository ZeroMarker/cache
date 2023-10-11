/// 名称: 辅助功能区 -引用属性格式的属性内容维护
/// 编写者: 基础数据平台组-石萧伟
/// 编写日期: 2018-05-22
 
var init = function(){			
	//列表datagrid
	$HUI.tree('#catTree',{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.MKB.MKBEncyclopedia&pClassMethod=GetDocSourseTreeJson&property="+property,
		lines:true,  //树节点之间显示线条
		autoSizeColumn:true,
		id:'id',//这里的id其实是所选行的idField列的值
		cascadeCheck:true,  //是否级联检查。默认true  菜单特殊，不级联操作     
		animate:false,   //是否树展开折叠的动画效果 
		checkbox:false,
		onLoadSuccess:function(data){
			//$("#FindTreeText").val("")
			//$HUI.radio("#myChecktreeFilterCK0").setValue(true)  //初始设置为全部
			/*var catStr=tkMakeServerCall("web.DHCBL.MKB.MKBTermProDetail","GetSelTermIdsStr",property)  //获取已选属性的id串
			if (catStr!="")
			{
				var array = catStr.split(',')
				for(var i=0;i<array.length;i++){
					var node= $('#catTree').tree('find',array[i])
					if ((node!=undefined)&(node!=null)&(node!=""))
					{
						$('#catTree').tree('check',node.target)  
					}
				}
			}*/
		}
			
	});
};
$(init);
