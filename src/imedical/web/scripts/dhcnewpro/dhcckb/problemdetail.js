var cmRowID = getParam("cmRowID");
var imgurl = "../scripts/dhcnewpro/dhcckb/images/"; //ͼ��·��
var color = ["#2AB66A","#FFB519","#FF5219","#000000"];	//��ɫ����ʾ�����ѡ���ʾ����ֹ
function InitPageDefault(){
	
	GetPatInfo();
	QueryProPrescList(cmRowID);
	GetProMsgInfo(cmRowID);
	
	$(".info-cage").hide();
	$(".tabs-header li:gt(0)").hide();
			
}

//���ز�����Ϣ
function GetPatInfo(){
	
	runClassMethod("web.DHCCKBProblemsPresc","GetPatInfo",{"cmRowID":cmRowID},	
		function(jsonString){	
			var jsonObject = jsonString;
			InitPatientInfo(jsonObject);
			
		},'json')
}

//չ�ֲ�����Ϣ
function InitPatientInfo(jsonObject){
	$("#name")[0].innerHTML = jsonObject.patName;
	$("#sex")[0].innerHTML = jsonObject.patSex;
	$("#age")[0].innerHTML = jsonObject.patAge;
	$("#weight")[0].innerHTML = jsonObject.patWeight;
	$("#height")[0].innerHTML = jsonObject.patHeight;
	$("#patNo")[0].innerHTML = jsonObject.patNo;
	$("#admNo")[0].innerHTML = jsonObject.admNo;
	$("#locDesc")[0].innerHTML = jsonObject.locDesc;
	$("#docDesc")[0].innerHTML = jsonObject.docDesc;
	$("#allergy")[0].innerHTML = jsonObject.allergy;
	$("#diagnosis")[0].innerHTML = jsonObject.diagnos;
}

/*��ѯ����*/
function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	$HUI.datebox("#sel-stDate").setValue(formatDate(0));
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

///���ش�����Ϣ
function QueryProPrescList(cmRowID)
{
	runClassMethod("web.DHCCKBProblemsPresc","QueryProPrescList",{"cmRowID":cmRowID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendPrescHtml(json);
	},'text');
}

///��������html
function AppendPrescHtml(json)
{
	
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	if (length <= 0){
		return;
	}
	var prescNo = "" //json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >����</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose;
		var preMet = json[i].preMet;
		var freq = json[i].freq;
		var treatment = json[i].treatment;
		var $cols = $("<div class='presc-drug'></div>");
		$prescInfo.append($cols);
		$cols.append("<span>"+(i+1)+"</span>");
		var spanHtml = "<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class='presc-text'>"+drugDesc+"</span><a  href='javascript:void(0);' onclick='litratrue(this)' style='float:right;padding-right:20px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'></a><br>";
	
		$cols.append(spanHtml);
	
		
		var $usecols = $("<div class='presc-pre'></div>");
		$prescInfo.append($usecols);
		$usecols.append("<span class='presc-use'>���μ�����</span>");
		$usecols.append("<span>"+ onceDose +"</span>");
		$usecols.append("<span class='presc-use'>��ҩ;����</span>");
		$usecols.append("<span>"+ preMet +"</span>");
		$usecols.append("<span class='presc-use'>Ƶ�Σ�</span>");
		$usecols.append("<span>"+ freq +"</span>");
		$usecols.append("<span class='presc-use'>�Ƴ̣�</span>");
		$usecols.append("<span>"+ treatment +"</span>");
		
		var $entrust = $("<div class='entrust'></div>");
		$prescInfo.append($entrust);
		var $contmore = $("<div class='contmore'></div>");
		$entrust.append($contmore);
		if(i<1){
			$contmore.append("<span></span>")

		}
		var $dashline = $('<div  id="dasline"></div>');
		if(i<length-1){
			$prescInfo.append($dashline);
		}
	}
}

///�����������
function GetProMsgInfo(cmRowID){
	
	runClassMethod("web.DHCCKBProblemsPresc","GetProMsgInfo",{"cmRowID":cmRowID},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendProbHtml(json);
	},'text');
}

///��������html
function AppendProbHtml(retJson)
{
	var $probInfo = $("#proInfo");
	$probInfo.empty();
	if ($.isEmptyObject(retJson)){
		return;	
	}
	var itemsArr = retJson.items;
	var arr = [];
	var keyArr = [];
	var manLevArr = [];
	//��ȡjson���ݣ���ȡһ�����
	for (var i = 0; i < itemsArr.length; i++){
		var warnsArr = itemsArr[i].warns;
		for (var j = 0; j < warnsArr.length; j++){
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					var obj = {};					
					obj.item = itemsArr[i].item;
					obj.manLev = warnsArr[j].manLev;
					obj.keyname = warnsArr[j].keyname;
					obj.val = valItemArr[x].val;
					arr.push(obj);					
				}
			}
		}		
	}
	
	//������ʾ�ȼ���������࣬ȥ��
	for (var n = 0; n < arr.length; n++){
		keyArr.push(arr[n].keyname);
		keyArr = unique(keyArr);
	}
	for (var m = 0; m < keyArr.length; m++){
		//������Ƭ
		var $keyCard = $("<div style=\"background-color:#FFFCF7;margin:20px 10px 10px 10px;height:auto;border:1px dashed #ccc;padding:10px;position:relative\"></div>");
		$probInfo.append($keyCard);	
		var manLevArr = [];
		for (var p = 0; p < arr.length; p++){
			if (arr[p].keyname == keyArr[m]){
				manLevArr.push(arr[p].manLev);	
			}	
		}
		manLevArr = unique(manLevArr);
		var manLevStr = manLevArr.join("");
		var setManLevel = "";
		if (manLevStr.indexOf("��ֹ")!=-1){
			setManLevel = "��ֹ"
		}else if(manLevStr.indexOf("��ʾ")!=-1){
			setManLevel = "��ʾ"
		}else if(manLevStr.indexOf("����")!=-1){
			setManLevel = "����"
		}else{
			setManLevel = "��ʾ"
		}
		var manLevIcon = (setManLevel == "��ʾ") ? "pro_tips.png" : (setManLevel == "����" ? "pro_remind.png" :(setManLevel == "��ʾ" ? "pro_warn.png" : (setManLevel == "��ֹ" ? "pro_forbid.png" : "")))
		var manLevcolor = (setManLevel == "��ʾ") ? color[0] : (setManLevel == "����" ? color[1] :(setManLevel == "��ʾ" ? color[2] : (setManLevel == "��ֹ" ? color[3] : "")))
		var $manLev = $("<div><img style=\"height:30px;position:absolute;left:-5px;top:-15px\" src = \""+ imgurl +""+manLevIcon+"\"/></div>");
		$keyCard.append($manLev);	
		
		for (var o = 0; o < manLevArr.length; o++){
			//��Ŀ���������ͼ��ͱ߿���ɫ
			//var manLevIcon = (manLevArr[o] == "��ʾ") ? "tips.png" : (manLevArr[o] == "����" ? "remind.png" :(manLevArr[o] == "��ʾ" ? "warn.png" : (manLevArr[o] == "��ֹ" ? "forbid.png" : "")))
			var manLevcolor = (manLevArr[o] == "��ʾ") ? color[0] : (manLevArr[o] == "����" ? color[1] :(manLevArr[o] == "��ʾ" ? color[2] : (manLevArr[o] == "��ֹ" ? color[3] : "")))
		
			var $infoCard = $("<div style=\"margin-top:-20px;padding:5px;width:70%;\"></div>");		
			$keyCard.append("<div style=\"width:25%;text-align:right;float:right;margin-top:15px;margin-right:30px;color:"+ manLevcolor +"\"><b>"+keyArr[m]+"</b></div>");
			$keyCard.append("<div style='clear:both;width:0px'></div>");	//�հ������ſ�����
			for (var r = 0; r < arr.length; r++){
				if (arr[r].keyname == keyArr[m]&&arr[r].manLev == manLevArr[o]){
					$infoCard.append("<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>")
					$infoCard.append(arr[r].item+"<br/>");
					$infoCard.append("<div style=\"color:#676360;font-size:12px;margin-left:25px;\">"+arr[r].val+"<br/></div>");	
				}	
			}
			$keyCard.append($infoCard);
		}
	}
}

/// ����ȥ�ط���
function unique(arr) {
    if (!Array.isArray(arr)) {
        console.log('type error!')
        return
    }
    var array = [];
    for (var i = 0; i < arr.length; i++) {
        if (array .indexOf(arr[i]) === -1) {
            array .push(arr[i])
        }
    }
    return array;
}


$(function(){ InitPageDefault(); });

