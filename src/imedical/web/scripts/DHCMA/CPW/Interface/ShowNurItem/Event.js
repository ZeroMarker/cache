//页面Event
function InitPathTypeListWinEvent(obj){
    obj.LoadEvent = function(args){ 
		//获取阶段类型
		$HUI.radio("[name='EpType']",{
	        onChecked:function(e,value){
		        if ($(e.target).attr("value")=="S"){
			    	//$('#cboCPWEp').next(".combo").show(); 
			    	$('#cboCPWEp').combobox('enable');  
			    }else{
				    //$('#cboCPWEp').next(".combo").hide(); 
					$('#cboCPWEp').combobox('clear').combobox('disable');
					obj.LoadGridNurItem();    
				}
	        }
	    });
		$('#btnCopy').on('click', function(){
	     	obj.btnCopy_click();
     	});
     }
	 
	//加载数据
	obj.LoadGridNurItem = function(){
		$('#gridNurItem').datagrid('loadData',{rows:[],total:0});
		var EpisID=""
		if ($("input[name='EpType']:checked").val()=="S"){
			EpisID = obj.PathwayID+"||"+$("#cboCPWEp").combobox('getValue')	
		}else{
			EpisID = obj.CurEpisID	
		}
		$cm({
			ClassName:"DHCMA.CPW.CPS.ImplementSrv",
			QueryName:"QryCPWStepInfo",
			aPathwayID:obj.PathwayID,
			aEpisID:EpisID,
			aType:"N",
			page:1,
			rows:99999
		},function(rs){
			$('#gridNurItem').datagrid('loadData',rs);
		})	
	}
	
	//引用
	obj.btnCopy_click = function(){
		var arrRows = obj.gridNurItem.getChecked();
		
     	if (arrRows.length == 0){
	    	$.messager.alert($g("提示"), $g("请先选中要引用的记录"), 'info');
			return; 	
	    }else{
			var result=""
			for (var i=0;i<arrRows.length;i++){
				var tmpResult = ""
				var itmInfo = arrRows[i].ItemInfo
				var itmNode = arrRows[i].Node.replace(RegExp("<br/>","g"),";")
				var tmpResult = itmInfo
				if(itmNode!="") tmpResult=tmpResult + "（" + itmNode + "）"
				result = result + tmpResult + "；"
			}
			//updatePreview($("#textEdit", parent.document)[0], result, getCursortPosition($("#textEdit", parent.document)[0]));   
			writToPreview(result);
		}		
	}
	 

}