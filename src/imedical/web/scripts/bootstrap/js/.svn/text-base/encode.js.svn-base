var EncodeURI = function(unzipStr,isCusEncode){
    if(isCusEncode){
        var zipArray = new Array();
        var zipstr = "";
        var lens = new Array();
        for(var i=0;i<unzipStr.length;i++){
         var ac = unzipStr.charCodeAt(i);
         zipstr += ac;
         lens = lens.concat(ac.toString().length);
        } 
        zipArray = zipArray.concat(zipstr);
        zipArray = zipArray.concat(lens.join("O"));
        return zipArray.join("N");
    }else{
        //return encodeURI(unzipStr);
        var zipstr=""; 
        var strSpecial="!\"#$%&'()*+,/:;<=>?[]^`{|}~%"; 
        var tt= "";

        for(var i=0;i<unzipStr.length;i++){ 
            var chr = unzipStr.charAt(i); 
            var c=StringToAscii(chr); 
            tt += chr+":"+c+"n"; 
            if(parseInt("0x"+c) > 0x7f){ 
                 zipstr+=encodeURI(unzipStr.substr(i,1));
            }else{ 
                 if(chr==" ") 
                    zipstr+="+"; 
                 else if(strSpecial.indexOf(chr)!=-1) 
                    zipstr+="%"+c.toString(16); 
                 else 
                    zipstr+=chr; 
                } 
            } 
        return zipstr; 
    }
}

var DecodeURI = function(zipStr,isCusEncode){
    if(isCusEncode){
        var zipArray = zipStr.split("N");
        var zipSrcStr = zipArray[0];
        var zipLens;
        if(zipArray[1]){
            zipLens = zipArray[1].split("O");    
        }else{
            zipLens.length = 0;
        }
        
        var uzipStr = "";
        
        for(var j=0;j<zipLens.length;j++){
            var charLen = parseInt(zipLens[j]);
            uzipStr+= String.fromCharCode(zipSrcStr.substr(0,charLen));
            zipSrcStr = zipSrcStr.slice(charLen,zipSrcStr.length);
        }        
        return uzipStr;
    }else{
        //return decodeURI(zipStr);
        var uzipStr=""; 

        for(var i=0;i<zipStr.length;i++){ 
            var chr = zipStr.charAt(i); 
            if(chr == "+"){ 
                 uzipStr+=" "; 
            }else if(chr=="%"){ 
                 var asc = zipStr.substring(i+1,i+3); 
                 if(parseInt("0x"+asc)>0x7f){ 
                     uzipStr+=decodeURI("%"+asc.toString()+zipStr.substring(i+3,i+9).toString()); ; 
                     i+=8; 
                 }else{ 
                     uzipStr+=AsciiToString(parseInt("0x"+asc)); 
                     i+=2; 
                 } 
            }else{ 
                 uzipStr+= chr; 
            } 
        } 
        return uzipStr;
    }
}

var StringToAscii = function(str){
    return str.charCodeAt(0).toString(16);
}

var AsciiToString = function(asccode){
    return String.fromCharCode(asccode);
}