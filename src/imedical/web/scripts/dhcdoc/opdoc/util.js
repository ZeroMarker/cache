(function(){
	opdoc={lib:{}};
})();
opdoc.lib.ns=function (){
	var len1 = arguments.length,
    i = 0,
    len2,
    j,
    main,
    ns,
    sub,
    current;
    
	for(; i < len1; ++i) {
	    main = arguments[i];
	    ns = arguments[i].split('.');
	    current = window[ns[0]];
	    if (current === undefined) {
	        current = window[ns[0]] = {};
	    }
	    sub = ns.slice(1);
	    len2 = sub.length;
	    for(j = 0; j < len2; ++j) {
	        current = current[sub[j]] = current[sub[j]] || {};
	    }
	}
	return current;
}
var opdoc=opdoc.lib.ns("opdoc");
opdoc.util=(function(){
	function genQueryArg(config,argCount,argObj){
		var obj=$.extend(true,{},config);
		obj["ArgCnt"]=argCount;
		for(var i=1;i<=argCount;++i){
			//obj["Arg"+i]=argObj[""+i]||"";
			obj["Arg"+i]=argObj["Arg"+i]||"";
		}
		return obj;
	}
	var eleIdMap = {};
	function genEleNewId(ele) {
		if (eleIdMap[ele]) {
			eleIdMap[ele]++;
		} else {
			eleIdMap[ele] = 1;
		}
		return ele + "_" + eleIdMap[ele];
	}
	//extend json data and join the pro and val for string
	function expandJsonHor(json){
		if(!json) return "";
		var str="";
		var valDeli=arguments[1]||String.fromCharCode(1);
		var proDeli=arguments[2]||String.fromCharCode(2);
		var arrDeli=arguments[3]||String.fromCharCode(3);
		var part=arguments[4]||[];
		var count=0;
		var prePro=part.length>0?part.join(".")+".":"";
		for(var pro in json){
			if(count>0) str+=valDeli;
			if($.type(json[pro]) === "array"){
				//if(json[pro].length==0) continue;
				var temp=""
				for(var ind in json[pro]){
					if(+ind>0) temp+=arrDeli;
					temp+=json[pro][ind];
				}
				str+=prePro+pro+proDeli+temp;
			}else if($.type(json[pro]) === "object"){
				part.push(pro);
				str+=expandJsonHor(json[pro],valDeli,proDeli,arrDeli,part);
				part.pop();
			}else{
				str+=prePro+pro+proDeli+json[pro];
			}
			count+=1;
		}
		return str;
	}
	function joinJsonPro(obj){
		if(!obj) return "";
		var arr=[];
		var joinCode=arguments[1]||"^"
		for(var pro in obj){
			arr.push(pro);
		}
		return arr.join(joinCode);
	}
	return {
		"genQueryArg":genQueryArg,
		"genEleNewId":genEleNewId,
		"expandJsonHor":expandJsonHor,
		"joinJsonPro":joinJsonPro
	};
})();