
/// ��ȡ����  bianshuai 2014-09-18
function getParam(paramName){
	
    var paramValue = "";
    var isFound = false;
    if (this.location.search.indexOf("?") == 0 && this.location.search.indexOf("=")>1){
        arrSource = unescape(this.location.search).substring(1,this.location.search.length).split("&");
        var i = 0;
        while (i < arrSource.length && !isFound){
            if (arrSource[i].indexOf("=") > 0){
                 if (arrSource[i].split("=")[0].toLowerCase()==paramName.toLowerCase()){
                    paramValue = arrSource[i].split("=")[1];
                    isFound = true;
                 }
            }
            i++;
        } 
    }
   return paramValue;
}

/// ��ʽ������  bianshuai 2014-09-18
function formatDate(t){
	
	var curr_Date = new Date();  
	curr_Date.setDate(curr_Date.getDate() + parseInt(t)); 
	var Year = curr_Date.getFullYear();
	var Month = curr_Date.getMonth()+1;
	var Day = curr_Date.getDate();
	return Year+"-"+Month+"-"+Day;
}

/// ����ַ���
function SplitString(TmpString, LimitLen){
	
	var TmpLabelArr = ["","","","","","","","","",""];   /// ��ʼ��������
	var Len = 0; j = 0; k = 0;
	/// bianshuai  ��ȡҩ��
	for (var i=0; i<TmpString.length; i++) {
		var vChar = TmpString.charCodeAt(i);   
		//���ֽڼ�1    
		if ((vChar >= 0x0001 && vChar <= 0x007e)||(0xff60 <= vChar && vChar <= 0xff9f)){   
			Len++;   
		}else{   
			Len+=2;   
		}
		
		if(((Len%LimitLen == 0)||(Len%LimitLen == 1))&(Len != 1)){
			
			if ((i - k) < 2) continue;
			TmpLabelArr[j] = TmpString.substr(k, i-k);  /// ��ȡ�ַ���
			if (j == 4){
				TmpLabelArr[j] = TmpLabelArr[j] + "...";   /// ���һ���ַ��������...
				break;
			}
			j = j + 1;
			k = i;
		}
		if ((i == TmpString.length - 1)&(k != i)){
			TmpLabelArr[j] = TmpString.substr(k, (i-k)+1);
		}
	}
	return TmpLabelArr;
}

/**ȥ���ַ���ǰ�����пո�*/
function trim(str){ 
	return str.replace(/(^\s*)|(\s*$)/g, ""); 
} 