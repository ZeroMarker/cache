var mutil = (function () {
	return {
		startDateH : new Date("1840-12-31"), //new Date(1840,11,31)--表示北京0点
		startDate : ["12/31/1840","31 Dec 1840","1840-12-31","31/12/1840","Dec 31, 1840","Dec 31 1840"],
		ms : 86400000, /*3600*1000*24,*/
		zdh : function(day,format){	/*日期转数字*/
			if ("number" !== typeof format){format = parseInt(format);}
			if ((format>0)&&(format<7)){
				var arr = [];
				if (format==1){
					var t = day.split("/");
					arr[0] = t[2], arr[1]=t[0], arr[2]=t[1];
				}
				if(format==4){	/* 日/月/年 转成 月/日/年 */
					var t = day.split("/");
					arr[0] = t[2], arr[1]=t[1], arr[2]=t[0];
					
				}
				if (format==3){
					var t = day.split("-");
					arr[0] = t[0], arr[1]=t[1], arr[2]=t[2];					
				}
				return (new Date(arr[0],arr[1]-1,arr[2],8)- this.startDateH)/this.ms;
			}else{
				return day;
			}
		},
		zd : function(day,format){    /*数字转日期*/
			if ("number" !== typeof format){format = parseInt(format);}
			if ((format>0)&&(format<7)){
				var tmpMonth = ["January","February","March","April","May","June","July","August","September","October","November","December"]
				var targetDay = "";
				var date = this.startDateH; //new Date(this.startDate[format-1]);
				var targetDayMs=date.getTime() + 1000*60*60*24*day;          
       			date.setTime(targetDayMs); //注意，这行是关键代码    
				var y = date.getFullYear();
				var m = date.getMonth()+1;
				var em = tmpMonth[m-1];
				var d = date.getDate();
				switch(format){
					case 1:
						targetDay = m+"/"+d+"/"+y;
						break;
					case 2:
						targetDay = d+"/"+em+"/"+y;
						break;	
					case 3: 
						targetDay = y+"-"+m+"-"+d;
						break;
					case 4:
						targetDay = d+"/"+m+"/"+y ;
						break;
					case 5:
						targetDay = em+" "+d+","+y;
						break;
					case 6:
						targetDay = em+" "+d+" "+y;
						break;
					default:
						break;
				}
			}
			return targetDay;
		},
		/**
		*@param : {String} time  12:19:19, 12, 12:20
		*@return : int 到0点的相差秒数
		*/
		 zth : function(time){
			var timeh = 0;
			var arr = time.split(":");
			var hour = arr[0];
			timeh = hour*60*60;
			if (arr.length>1){
				var minute = arr[1];
				timeh += parseInt(minute*60);
				if(arr.length>2){
					timeh += parseInt(arr[2]);
				}
			}
			return timeh;
		},
		/**
		*@param : {Float} timeh 从0时开始到现在秒数   
		*@param : {Int} type 1 --- return hh:mm
		*              	     2 --- return hh:mm:ss  default;
		*@return : 返回时间
		*/
		zt : function(timeh,type){
			if (parseFloat(timeh)) {
				timeh = timeh % 86400;
				var hour =  parseInt(timeh / 3600);
				var minute = timeh % 3600;
				var sec = minute%60;
				var minute = parseInt(minute / 60);
				type = type || 2;
				if(type==1){
					return hour+":"+minute+":"+sec;
				}
				if(type==2){
					return hour+":"+minute
				}
				return hour+":"+minute;
			}else{
				return timeh;
			}
		}
	}
})();