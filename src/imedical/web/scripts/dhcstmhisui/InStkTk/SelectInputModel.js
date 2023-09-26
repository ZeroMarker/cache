var SelectModel=function(row,Fn){
	  var InputType=row.InputType;
	  var locid=row.loc;
	  var HVFlag=row.HighValueFlag;
	  var InStkTkWin = $HUI.combobox('#InStkTkWin', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInStkTkWindow&ResultSetType=array&LocId='+locid,
			valueField: 'RowId',
			textField: 'Description'
	  });
	  $HUI.dialog('#SelectModel').open()
	  $UI.linkbutton('#FCancelBT',{
		  onClick:function(){
		  	$UI.clearBlock('#SelectModelConditions');
			 $HUI.dialog('#SelectModel').close();
		  }
	  });
	  $UI.linkbutton('#FSuerBT',{
		  onClick:function(){
			 returnData()
		  }
	  });
	  function returnData() {
	  	var checkedInputTypeRadioJObj = $("input[name='InputType']:checked");
	  	var selectModel=checkedInputTypeRadioJObj.val();
	  	if(isEmpty(selectModel)){
	  		$UI.msg('alert','��ѡ��¼�뷽ʽ!');
	  	}else {
	  		var instwWin=$('#InStkTkWin').combobox('getValue');
	  		Fn(selectModel, instwWin);
	  		$HUI.dialog('#SelectModel').close();
	  	}
	  }
	  init();
	  function init(){
	  	$UI.clearBlock('#SelectModelCondition');
	  	$HUI.radio("#systel1").enable();
		$HUI.radio("#systel2").enable();
		$HUI.radio("#systel3").enable();
		$HUI.radio("#systel4").enable();
	  	if(InputType==3||(HVFlag=="Y")){
	  		$("#InStkTkWin").combobox({disabled: true});  
	  	}else{
	  		$("#InStkTkWin").combobox({disabled: false});  
	  	}
		if((isEmpty(InputType)||InputType==1)&&(HVFlag!="Y")){
			$HUI.radio("#systel1").setValue(true);
	    }else if(InputType==2){
	    	$HUI.radio("#systel3").setValue(true);
	    }else if(InputType==3||(HVFlag=="Y")){
	    	$HUI.radio("#systel4").setValue(true);
	    }
	    if((!isEmpty(InputType)&&InputType!=1)||(HVFlag=="Y")){
		  	$HUI.radio("#systel1").disable();
		  	$HUI.radio("#systel2").disable();
	    }
	    if((!isEmpty(InputType)&&InputType!=2)||(HVFlag=="Y")){
	    	$HUI.radio("#systel3").disable();
	    }
	    if(InputType!=3 && HVFlag!="Y"){
			$HUI.radio("#systel4").disable();
	    }
	    
	  }
	  
}