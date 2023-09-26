var UnWomenPanel=(function(){
	function Init(){
		InitPageComponent();
		LoadTestItemList();
		LoadOtherInfo();
	}
	/// 初始化界面控件内容
	function InitPageComponent(){
		
		/// 首次发现人乳头瘤病毒时间
		$('#FoundDate').datebox().datebox('calendar').calendar({
			validator: function(date){
				var now = new Date();
				return date<=now;
			}
		});
		
		// 既往手术史增加无选项及切换效果 qunianpeng 2018/8/28
		$("#PrevHisFlag1").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$HUI.checkbox("#PrevHisFlag2").setValue(false)
				$("#PrevContent").css('display','block');
			};			
		})
		$("#PrevHisFlag2").on('click',function(){			
			if($("#"+this.id).is(':checked')){
				$HUI.checkbox("#PrevHisFlag1").setValue(false)
				$("#PrevContent").css('display','none');
			};			
		})
		
	}
	/// 加载HPV病人病历内容
	function LoadTestItemList(){
		
		/// 初始化检查方法区域
		$("#TesItem").html('<tr style="height:0px;" ><td style="width:20px;"></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td><td style="width:20px;"></td><td></td></tr>');
		runClassMethod("web.DHCAppPisMasterQuery","JsonItemList",{"HospID": LgHospID},function(jsonString){

			if (jsonString != ""){
				var jsonObjArr = jsonString;
				for (var i=0; i<jsonObjArr.length; i++){
					InsTesItemRegion(jsonObjArr[i]);
				}
			}
		},'json',false)
	}

	/// HPV病人病历内容
	function InsTesItemRegion(itemobj){	
		/// 标题行
		var htmlstr = '';
			htmlstr = '<tr style="height:30px"><td colspan="9" class=" tb_td_required" style="border:0px solid #ccc;font-weight:bold;">'+ itemobj.text +'</td></tr>';

		/// 项目
		var itemArr = itemobj.items;
		var itemhtmlArr = []; itemhtmlstr = "";
		for (var j=1; j<=itemArr.length; j++){
			
			itemhtmlArr.push('<td style="width:30px;"><input id="'+ itemArr[j-1].value +'" name="'+ itemArr[j-1].name +'" type="checkbox" value="'+ itemArr[j-1].value +'"></input></td><td>'+ itemArr[j-1].text +'</td>');
			if (j % 4 == 0){
				itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '</tr>';
				itemhtmlArr = [];
			}
		}
		if ((j-1) % 4 != 0){
			itemhtmlstr = itemhtmlstr + '<tr><td></td>' + itemhtmlArr.join("") + '<td style="width:30px"></td><td></td></tr>';
			itemhtmlArr = [];
		}
		$("#TesItem").append(htmlstr+itemhtmlstr)
	}
	function LoadOtherInfo(){
		var OtherInfo=""
		if (itemReqJsonStr!=""){
			for (var i = 0; i < itemReqJsonStr.length; i++) {
				var OneReqJson=itemReqJsonStr[i]
				var ID=OneReqJson.ID
				var Val=OneReqJson.Val
				if (ID="OtherInfo") OtherInfo=Val
			}
		}
		if (OtherInfo!=""){
			OtherObj=$.parseJSON(OtherInfo); 
			mPisTesItm=$.parseJSON(OtherObj["mPisTesItmMet"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TesItmMet]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["mPisTesDiag"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TesDiag]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			mPisTesItm=$.parseJSON(OtherObj["mPisTreMet"])
			for (var i = 0; i < mPisTesItm.length; i++) {
				var Psiarry=mPisTesItm[i]
				var PsiID=Psiarry.split("^")[0]
				var PisTesItmArr = $("input[name=TreMet]");
	    		for (var j=0; j < PisTesItmArr.length; j++){
		    		if (PisTesItmArr[j].id==PsiID){
							$('#'+PsiID).attr("checked",true);
			    		}
		    		}
				}
			}
		}

	function OtherInfo(){
		/// 检测方法
		var mPisTesItmMetArr=[]; var mPisTesItmMet="";
		var TesItmMetArr = $("input[name=TesItmMet]");
		for (var i=0; i < TesItmMetArr.length; i++){
		    if($("[value='"+TesItmMetArr[i].value+"'][name=TesItmMet]").is(':checked')){
				mPisTesItmMetArr.push(TesItmMetArr[i].value);
		    }
		}
		var mPisTesItmMet = JSON.stringify(mPisTesItmMetArr);

		/// 临床诊断
		var mPisTesDiagArr=[]; var mPisTesDiag="";
		var TesDiagArr = $("input[name=TesDiag]");
		for (var j=0; j < TesDiagArr.length; j++){
		    if($("[value='"+TesDiagArr[j].value+"'][name=TesDiag]").is(':checked')){
				mPisTesDiagArr.push(TesDiagArr[j].value);
		    }
		}
		var mPisTesDiag = JSON.stringify(mPisTesDiagArr);

		/// 治疗方式
		var mPisTreMetArr=[]; var mPisTreMet="";
		var TreMetArr = $("input[name=TreMet]");
		for (var n=0; n < TreMetArr.length; n++){
		    if($("[value='"+TreMetArr[n].value+"'][name=TreMet]").is(':checked')){
				mPisTreMetArr.push(TreMetArr[n].value);
		    }
		}
		var mPisTreMet = JSON.stringify(mPisTreMetArr);
		var rtnObj = {}
		rtnObj["mPisTesItmMet"] = mPisTesItmMet;
		rtnObj["mPisTesDiag"] = mPisTesDiag;
		rtnObj["mPisTreMet"] = mPisTreMet;
		return rtnObj
		}
	function PrintInfo(){
		return ""
		}
	return {
		"Init":Init,
		"OtherInfo":OtherInfo,
		"PrintInfo":PrintInfo,
		}
	   
})();