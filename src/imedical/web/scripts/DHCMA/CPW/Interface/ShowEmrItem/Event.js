//ҳ��Event
function InitPathTypeListWinEvent(obj){
    obj.LoadEvent = function(args){ 
		//��ȡ�׶�����
		$HUI.radio("[name='EpType']",{
	        onChecked:function(e,value){
		        if ($(e.target).attr("value")=="S"){
			    	//$('#cboCPWEp').next(".combo").show(); 
			    	$('#cboCPWEp').combobox('enable');  
			    }else{
				    //$('#cboCPWEp').next(".combo").hide(); 
					$('#cboCPWEp').combobox('clear').combobox('disable');
					obj.LoadGridEmrItem();    
				}
	        }
	    });
		$('#btnCopy').on('click', function(){
	     	obj.btnCopy_click();
     	});
     }
	 
	//��������
	obj.LoadGridEmrItem = function(){
		$('#gridEmrItem').datagrid('loadData',{rows:[],total:0});
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
			aType:"T",
			page:1,
			rows:99999
		},function(rs){
			$('#gridEmrItem').datagrid('loadData',rs);
		})	
	}
	
	//����
	obj.btnCopy_click = function(){
		
		var resultItems = new Array();
		var arrRows = obj.gridEmrItem.getChecked();
     	if (arrRows.length == 0){
	    	$.messager.alert($g("��ʾ"), $g("����ѡ��Ҫ���õļ�¼"), 'info');
			return; 	
	    }else{
			var result=""
			for (var i=0;i<arrRows.length;i++){
				var tmpResult = ""
				var itmInfo = arrRows[i].ItemInfo
				var itmNode = arrRows[i].Node.replace(RegExp("<br/>","g"),";")
				var tmpResult = itmInfo
				if(itmNode!="") tmpResult=tmpResult + "��" + itmNode + "��"
				result = result + tmpResult + "��"
			}
			
			// �����ⲿҳ�淽��ʵ�����ù���
			resultItems.push({ "TEXT": result });
		    var param = { "action": "INSERT_STYLE_TEXT_BLOCK", "args": { "items": resultItems } };
		    parent.eventDispatch(param);
    
		}		
	}
	 

}