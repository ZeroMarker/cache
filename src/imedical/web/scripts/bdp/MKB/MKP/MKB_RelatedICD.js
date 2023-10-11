/** 
 * @Title: 相关ICD查询
 * @Description:根据诊断获查询相关ICD
 * @Creator: 高姗姗
 * @Created: 2018-05-15
 */

 var rowidstr = GetParams("diag");
 var version = GetParams("version")
 var dblflag = GetParams("dblflag");
 var DiagnosValue = GetParams("DiagnosValue");
 if (DiagnosValue==null){DiagnosValue=""}
 function GetParams(name){
        var search = document.location.search;
        var pattern = new RegExp("[?&]"+name+"\=([^&]+)", "g");
        var matcher = pattern.exec(search);
        var items = null;
        if(null != matcher){
                try{
                        items = decodeURIComponent(decodeURIComponent(matcher[1]));
                }catch(e){
                        try{
                                items = decodeURIComponent(matcher[1]);
                        }catch(e){
                                items = matcher[1];
                        }
                }
        }
        return items;
};
function BodyLoadHandler()
{
	var ClassName="web.DHCBL.MKB.MKBKLMappingDetailInterface"
	if (version.indexOf("ICD")>-1){
		ClassName="web.DHCBL.MKB.MKBICDContrastInterface"
	}
	var columns =[[   
					//DiagExp,MRCID,HISCode,HISDesc
					{field:'HISCode',title:'HIS ICD编码',width:120},
					{field:'HISDesc',title:'HIS ICD释义',width:300},
					{field:'DiagExp',title:'诊断表达式',width:300},    
					{field:'MRCID',title:'HISICDid',hidden:true} 
				]];
	var icdgrid = $HUI.datagrid("#icdgrid",{
		/*data: [
			{'HISCode':'C85.100', 'HISDesc':'B细胞淋巴瘤','DiagExp':'淋巴瘤(分型=B细胞)','MRCID':'2527'},
			{'HISCode':'C85.900', 'HISDesc':'非霍奇金淋巴瘤','DiagExp':'淋巴瘤(分型=非霍奇金)','MRCID':'2535'}
		],*/
		url:$URL,
		queryParams:{
			ClassName:ClassName,
			//QueryName:"GetICD", //协和ICD
			//QueryName:"GetICDForHIS", //安贞ICD
			QueryName:"GetICDForCMB", //标版
			version:version,
			str:rowidstr
		},
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		idField:'MRCID', 
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true,   //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onDblClickRow: function(rowIndex, rowData){
			if (dblflag=="Y"){
				DbClickICDFun(rowIndex, rowData,DiagnosValue)
			}
		},
		onLoadSuccess:function(data){
			/*for (var i=0;i<data.rows.length;i++){
				if (data.rows[i]["MRCID"]==hisid){
					$('#icdgrid').datagrid('selectRow',i);
					break;
				}
			}*/
		}
	});  
	
	
	
		//双击相关icd列表的数据时进行保存
	function DbClickICDFun(rowIndex, rowData,DiagnosValue)
	{
		var linkICDRowid="",hisicd=""
		var row = $("#icdgrid").datagrid("getSelected");  
		if (row){
			var linkICDRowid=row.MRCID
			var hisicd=row.HISCode+" "+row.HISDesc
		}		
		if (linkICDRowid==""){
			alert("请选择一条关联ICD记录!");
			return false;
		}
		if (DiagnosValue!=""){ //结构化查询列表关联ICD修改
			//医生端诊断关联ICD修改
			//var ret=tkMakeServerCall("web.DHCMRDiagnos","UpdateDiagLinICDDr",DiagnosValue,linkICDRowid);
			var ret=tkMakeServerCall("web.DHCBL.MKB.SDSStructDiagnosApply","UpdateDiagLinICDDr",DiagnosValue,linkICDRowid);
			if (ret=="0"){
				window.parent.close();
				window.opener.document.getElementById("textICD").value=hisicd;
				//刷新诊断列表
				
			}else{
				$.messager.alert("提示","修改关联ICD失败!")
			}
			
		}else{ //智能提示关联ICD重新赋值
			window.parent.$("#myWinRelatedICD").dialog("close");
			window.parent.$("#relaticd").text(hisicd);  
			window.parent.$("#relaticdid").text(linkICDRowid); 
		}
	}
      
}


