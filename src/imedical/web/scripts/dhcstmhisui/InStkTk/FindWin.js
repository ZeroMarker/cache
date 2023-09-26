var FindWin=function(Fn){
	  $UI.clearBlock('#FindWin');
	  var FRecLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	  var FRecLocBox = $HUI.combobox('#FLocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	  });	
	  var Dafult={
	  		FLocId:gLocObj,
			FStartDate:DateFormatter(new Date()),
			FEndDate:DateFormatter(new Date()),
			FInstComp:"",
			FStkTkComp:"N",
			FAdjComp:"N"
			}
	  $UI.fillBlock('#FindWin',Dafult)
	  $HUI.dialog('#FindWin').open()
	  $UI.linkbutton('#FCancelBT',{
		  onClick:function(){
			 $HUI.dialog('#FindWin').close();
		  }
	  });
	  $UI.linkbutton('#FSuerBT',{
		  onClick:function(){
			 var ParamsObj=$UI.loopBlock('#FindWin');
		   	 var phaLoc = ParamsObj.FLocId;
		     if (isEmpty(phaLoc)) {
			    $UI.msg('alert','«Î—°‘Òø∆ “!');
			    return false;
		      }
			 Fn(ParamsObj);
			 $HUI.dialog('#FindWin').close();
			 
		  }
	  });
	  
	  
}