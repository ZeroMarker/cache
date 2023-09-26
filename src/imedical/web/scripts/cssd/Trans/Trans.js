var init = function() {
	//�����������б�
    var OprBox = $HUI.combobox('#OprPkg', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=1,2,7',
        valueField: 'RowId',
        textField: 'Description',
		onSelect: function (row) {
                    if (row != null) {
						//alert(row.RowId);
                        $HUI.combobox('#CodeDict', {
                          url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array&PkgDr='+row.RowId,
                          valueField: 'RowId',
                          textField: 'Description'
                      }); 
                    }
                }

    });
    
    //��ϴ�������б�
    var UserLocBox = $HUI.combobox('#User', {
        url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
        valueField: 'RowId',
        textField: 'Description'
    });
	//����ѡ�񱨱����͹��˲�ѯ����
	    $HUI.radio("[name='ReportType']",{
			//var v1 = document.getElementById("tr1");
			//var v2 = document.getElementById("tr2");
			
            onChecked:function(e,value){
               if($(e.target).attr("value")=="FlagSterilizeBatchTrace"){
					$("#stdate").css('display' ,'none');
					$("#endate").css('display' ,'none');
					$("#sttime").css('display' ,'none');
					$("#endtime").css('display' ,'none');
					$("#ptype").css('display' ,'none');
					$("#user").css('display' ,'none');
					$("#pkgdr").css('display' ,'none');
					$("#codedict").css('display' ,'none');
					$("#labelv").css('display' ,'none');
					//$("#ste").css('display' ,'block');
					var v2 = document.getElementById("ste");
					v2.style.display="";
			   }
			   else
			   {
					$("#stdate").css('display' ,'');
					$("#endate").css('display' ,'');
					$("#sttime").css('display' ,'');
					$("#endtime").css('display' ,'');
					$("#ptype").css('display' ,'');
					$("#user").css('display' ,'');
					$("#pkgdr").css('display' ,'');
					$("#codedict").css('display' ,'');
					$("#labelv").css('display' ,'');
					var v2 = document.getElementById("ste");
					v2.style.display="none";
			   }
            }
        });
   

	/*--��ť�¼�--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			} 
			
			var Params=JSON.stringify(ParamsObj);
			//alert(Params);
			Params=encodeUrlStr(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Conditions=GetConditions(ParamsObj)
			var Url=CheckedUrl(CheckedValue,Params,Conditions)
			AddTab(CheckedTitle,Url);
		}
	});
	///ƴ��url
	function CheckedUrl(Checked,Params,Conditions){
		//alert(Params);
		//alert(Conditions);
		//��ⵥ�б�
		if('FlagPackageProcessTrans'==Checked){
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_StatPackageTrans.raq&Params='+Params+'&Conditions='+Conditions;
		}else if('FlagSterilizeBatchTrace'==Checked){
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_SterilizeBatchTrace.raq&Params='+Params+'&Conditions='+Conditions;
		}
		
		return p_URL;
	}
	//��֯��ѯ����
	function GetConditions(ParamsObj){
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" ͳ��ʱ��: "+ParamsObj.StartDate
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate
		}
		return Conditions;
	}
	function AddTab(title, url) {
		if ($('#tabs').tabs('exists', title)) {
			$('#tabs').tabs('select', title); //ѡ�в�ˢ��
			var currTab = $('#tabs').tabs('getSelected');
			if (url != undefined && currTab.panel('options').title != '����') {
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: createFrame(url)
					}
				})
			}
		} else {
			var content = createFrame(url);
			$('#tabs').tabs('add', {
				title: title,
				content: content,
				closable: true
			});
		}
	}
	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:98%;"></iframe>';
		return s;
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	
	/*--�󶨿ؼ�--*/
	
	/*--���ó�ʼֵ--*/
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date())
			}
		$UI.fillBlock('#Conditions',DefaultValue)
		var Tabs=$('#tabs').tabs('tabs')
		var Tiles = new Array();
		var Len = Tabs.length;
		if(Len>0){
			for(var j=0;j<Len;j++){
				var Title = Tabs[j].panel('options').title;
				if(Title!='����'){
					Tiles.push(Title);
				}
			}
			for(var i=0;i<Tiles.length;i++){
				$('#tabs').tabs('close', Tiles[i]);
			}
		}
		
	};
	Default()
}
$(init);