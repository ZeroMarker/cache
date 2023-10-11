/**
 * ������ƴ����ת���ߣ����ݵ�����ֵ��ļ��Ĳ�֧ͬ�ֲ�ͬ
 * ���ڶ�����Ŀǰֻ�ǽ����п��ܵ���������׼ȷʶ���������Ҫ���ƵĴʿ⣬���ʿ��ļ��������ֿ⻹Ҫ�����Բ�̫�ʺ�web������
 * @start 2016-09-26
 * @last 2016-09-29
 */
 ;(function(global, factory) {
	if (typeof module === "object" && typeof module.exports === "object") {
		module.exports = factory(global);
	} else {
		factory(global);
	}
})(typeof window !== "undefined" ? window : this, function(window) {

	var toneMap = 
	{
		"��": "a1",
		"��": "a2",
		"��": "a3",
		"��": "a4",
		"��": "o1",
		"��": "o2",
		"��": "o3",
		"��": "o4",
		"��": "e1",
		"��": "e2",
		"��": "e3",
		"��": "e4",
		"��": "i1",
		"��": "i2",
		"��": "i3",
		"��": "i4",
		"��": "u1",
		"��": "u2",
		"��": "u3",
		"��": "u4",
		"��": "v0",
		"��": "v1",
		"��": "v2",
		"��": "v3",
		"��": "v4",
		"��": "n2",
		"��": "n3",
		"?": "m2"
	};

	var dict = {}; // �洢�����ֵ�����
	var pinyinUtil =
	{
		/**
		 * ���������ֵ��ļ���������ֵ��ļ������ڱ�JS֮ǰ����
		 */
		parseDict: function()
		{
			// ��������� pinyin_dict_firstletter.js
			if(window.pinyin_dict_firstletter)
			{
				dict.firstletter = pinyin_dict_firstletter;
			}
			// ��������� pinyin_dict_notone.js
			if(window.pinyin_dict_notone)
			{
				dict.notone = {};
				dict.py2hz = pinyin_dict_notone; // ƴ��ת����
				for(var i in pinyin_dict_notone)
				{
					var temp = pinyin_dict_notone[i];
					for(var j=0, len=temp.length; j<len; j++)
					{
						if(!dict.notone[temp[j]]) dict.notone[temp[j]] = i; // �����Ƕ�����
					}
				}
			}
			// ��������� pinyin_dict_withtone.js
			if(window.pinyin_dict_withtone)
			{
				dict.withtone = {}; // ������ƴ��ӳ�䣬�������ÿո�ֿ����������ֽṹ��{'��': 'da tai'}
				var temp = pinyin_dict_withtone.split(',');
				for(var i=0, len = temp.length; i<len; i++)
				{
					// ��δ����ʱ28�������ң�������Ӱ�첻������һ���Դ������
					dict.withtone[String.fromCharCode(i + 19968)] = temp[i]; // �����Ȳ�����split(' ')����Ϊһ����ѭ��2���split�Ƚ���������
				}

				// ƴ�� -> ����
				if(window.pinyin_dict_notone)
				{
					// ����ƴ��ת���֣���������ʹ��pinyin_dict_notone�ֵ��ļ�
					// ��Ϊ����ֵ��ļ���������Ƨ�֣����Ѱ��պ���ʹ��Ƶ������
					dict.py2hz = pinyin_dict_notone; // ƴ��ת����
				}
				else
				{
					// ���ֵ��ļ�������ƴ��->���ֵĽṹ
					// ���ȷָ�����ȥ��������ȣ���һ����ȫ��ȥ������Ȼ���ٷָ��ٶ����ٿ���3����ǰ�ߴ�Լ��Ҫ120���룬���ߴ�Լֻ��Ҫ30���루Chrome�£�
					var notone = pinyinUtil.removeTone(pinyin_dict_withtone).split(',');
					var py2hz = {}, py, hz;
					for(var i=0, len = notone.length; i<len; i++)
					{
						hz = String.fromCharCode(i + 19968); // ����
						py = notone[i].split(' '); // ȥ����������ƴ������
						for(var j=0; j<py.length; j++)
						{
							py2hz[py[j]] = (py2hz[py[j]] || '') + hz;
						}
					}
					dict.py2hz = py2hz;
				}
			}
		},
		/**
		 * ���ݺ��ֻ�ȡƴ����������Ǻ���ֱ�ӷ���ԭ�ַ�
		 * @param chinese Ҫת���ĺ���
		 * @param splitter �ָ��ַ���Ĭ���ÿո�ָ�
		 * @param withtone ���ؽ���Ƿ����������Ĭ����
		 * @param polyphone �Ƿ�֧�ֶ����֣�Ĭ�Ϸ�
		 */
		getPinyin: function(chinese, splitter, withtone, polyphone)
		{
			if(!chinese || /^ +$/g.test(chinese)) return '';
			splitter = splitter == undefined ? ' ' : splitter;
			withtone = withtone == undefined ? true : withtone;
			polyphone = polyphone == undefined ? false : polyphone;
			var result = [];
			if(dict.withtone) // ����ʹ�ô��������ֵ��ļ�
			{
				var noChinese = '';
				for (var i=0, len = chinese.length; i < len; i++)
				{
					var pinyin = dict.withtone[chinese[i]];
					if(pinyin)
					{
						// �������Ҫ�����֣�Ĭ�Ϸ��ص�һ��ƴ���������ֱ�Ӻ���
						// ������������ֵ���һ��Ҫ�󣬳����ֵ�ƴ�����������ǰ��
						if(!polyphone) pinyin = pinyin.replace(/ .*$/g, '');
						if(!withtone) pinyin = this.removeTone(pinyin); // �������Ҫ����
						//�ո񣬰�noChinese��Ϊһ���ʲ���
						noChinese && ( result.push( noChinese), noChinese = '' );
						result.push( pinyin ); 
					}
					else if ( !chinese[i] || /^ +$/g.test(chinese[i]) ){
						//�ո񣬰�noChinese��Ϊһ���ʲ���
						noChinese && ( result.push( noChinese), noChinese = '' );
					}
					else{
						noChinese += chinese[i];
					}
				}
				if ( noChinese ){
					result.push( noChinese);
					noChinese = '';
				}
			}
			else if(dict.notone) // ʹ��û���������ֵ��ļ�
			{
				if(withtone) console.warn('pinyin_dict_notone �ֵ��ļ���֧��������');
				if(polyphone) console.warn('pinyin_dict_notone �ֵ��ļ���֧�ֶ����֣�');
				var noChinese = '';
				for (var i=0, len = chinese.length; i < len; i++)
				{
					var temp = chinese.charAt(i),
						pinyin = dict.notone[temp];
					if ( pinyin ){ //����ƴ��
						//�ո񣬰�noChinese��Ϊһ���ʲ���
						noChinese && ( result.push( noChinese), noChinese = '' );
						result.push( pinyin );
					}
					else if ( !temp || /^ +$/g.test(temp) ){
						//�ո񣬲���֮ǰ�ķ������ַ�
						noChinese && ( result.push( noChinese), noChinese = '' );
					}
					else {
						//�ǿո񣬹�����noChinese��
						noChinese += temp;
					}
				}

				if ( noChinese ){
					result.push( noChinese );
					noChinese = '';
				}
			}
			else
			{
				throw '��Ǹ��δ�ҵ����ʵ�ƴ���ֵ��ļ���';
			}
			if(!polyphone) return result.join(splitter);
			else
			{
				if(window.pinyin_dict_polyphone) return parsePolyphone(chinese, result, splitter, withtone);
				else return handlePolyphone(result, ' ', splitter);
			}
		},
		/**
		 * ��ȡ���ֵ�ƴ������ĸ
		 * @param str �����ַ�������������Ǻ�����ԭ������
		 * @param polyphone �Ƿ�֧�ֶ����֣�Ĭ��false�����Ϊtrue���᷵�����п��ܵ��������
		 */
		getFirstLetter: function(str, polyphone)
		{
			polyphone = polyphone == undefined ? false : polyphone;
			if(!str || /^ +$/g.test(str)) return '';
			if(dict.firstletter) // ʹ������ĸ�ֵ��ļ�
			{
				var result = [];
				for(var i=0; i<str.length; i++)
				{
					var unicode = str.charCodeAt(i);
					var ch = str.charAt(i);
					if(unicode >= 19968 && unicode <= 40869)
					{
						ch = dict.firstletter.all.charAt(unicode-19968);
						if(polyphone) ch = dict.firstletter.polyphone[unicode] || ch;
					}
					result.push(ch);
				}
				if(!polyphone) return result.join(''); // ������ùܶ����֣�ֱ�ӽ�����ƴ�ӳ��ַ���
				else return handlePolyphone(result, '', ''); // ��������֣���ʱ��result�����ڣ�['D', 'ZC', 'F']
			}
			else
			{
				var py = this.getPinyin(str, ' ', false, polyphone);
				py = py instanceof Array ? py : [py];
				var result = [];
				for(var i=0; i<py.length; i++)
				{
					result.push(py[i].replace(/(^| )(\w)\w*/g, function(m,$1,$2){return $2.toUpperCase();}));
				}
				if(!polyphone) return result[0];
				else return simpleUnique(result);
			}
		},
		/**
		 * ƴ��ת���֣�ֻ֧�ֵ������֣���������ƥ��ĺ������
		 * @param pinyin �������ֵ�ƴ�������԰�������
		 */
		getHanzi: function(pinyin)
		{
			if(!dict.py2hz)
			{
				throw '��Ǹ��δ�ҵ����ʵ�ƴ���ֵ��ļ���';
			}
			return dict.py2hz[this.removeTone(pinyin)] || '';
		},
		/**
		 * ��ȡĳ�����ֵ�ͬ���֣���������ʱ�����⣬������
		 * @param hz ��������
		 * @param sameTone �Ƿ��ȡͬ��ͬ�����ĺ��֣����봫������ƴ����������֧�֣�Ĭ��false
		 */
		getSameVoiceWord: function(hz, sameTone)
		{
			sameTone = sameTone || false
			return this.getHanzi(this.getPinyin(hz, ' ', false))
		},
		/**
		 * ȥ��ƴ���е����������罫 xi��o m��ng t��ng xu�� ת���� xiao ming tong xue
		 * @param pinyin ��Ҫת����ƴ��
		 */
		removeTone: function(pinyin)
		{
			return pinyin.replace(/[������������������������������������������������������?]/g, function(m){ return toneMap[m][0]; });
		},
		/**
		 * ������ƴ��ת���������Ĵ�����ƴ��
		 * @param pinyinWithoutTone ���� xu2e�����Ĵ����ֵ�ƴ��
		 */
		getTone: function(pinyinWithoutTone)
		{
			var newToneMap = {};
			for(var i in toneMap) newToneMap[toneMap[i]] = i;
			return (pinyinWithoutTone || '').replace(/[a-z]\d/g, function(m) {
				return newToneMap[m] || m;
			});
		}
	};


	/**
	 * ��������֣�������['D', 'ZC', 'F']ת����['DZF', 'DCF']
	 * ���߽� ['chang zhang', 'cheng'] ת���� ['chang cheng', 'zhang cheng']
	 */
	function handlePolyphone(array, splitter, joinChar)
	{
		splitter = splitter || '';
		var result = [''], temp = [];
		for(var i=0; i<array.length; i++)
		{
			temp = [];
			var t = array[i].split(splitter);
			for(var j=0; j<t.length; j++)
			{
				for(var k=0; k<result.length; k++)
					temp.push(result[k] + (result[k]?joinChar:'') + t[j]);
			}
			result = temp;
		}
		return simpleUnique(result);
	}

	/**
	 * ���ݴʿ��ҳ���������ȷ�Ķ���
	 * ����ֻ�Ƿǳ��򵥵�ʵ�֣�Ч�ʺ�Ч������һЩ����
	 * �Ƽ�ʹ�õ������ִʹ����ȶԾ��ӽ��зִʣ�Ȼ����ƥ�������
	 * @param chinese ��Ҫת���ĺ���
	 * @param result ����ƥ������İ������������ƴ�����
	 * @param splitter ���ؽ��ƴ���ַ�
	 */
	function parsePolyphone(chinese, result, splitter, withtone)
	{
		var poly = window.pinyin_dict_polyphone;
		var max = 7; // ���ֻ����7�����ֵĶ����ִʣ���Ȼ�ʿ�������10���ֵģ����������ǳ��٣�Ϊ������Ч����ʱ����֮
		var temp = poly[chinese];
		if(temp) // ���ֱ���ҵ��˽��
		{
			temp = temp.split(' ');
			for(var i=0; i<temp.length; i++)
			{
				result[i] = temp[i] || result[i];
				if(!withtone) result[i] = pinyinUtil.removeTone(result[i]);
			}
			return result.join(splitter);
		}
		for(var i=0; i<chinese.length; i++)
		{
			temp = '';
			for(var j=0; j<max && (i+j)<chinese.length; j++)
			{
				if(!/^[\u2E80-\u9FFF]+$/.test(chinese[i+j])) break; // ��������Ǻ���ֱ��ֹͣ���β���
				temp += chinese[i+j];
				var res = poly[temp];
				if(res) // ����ҵ��˶����ִ���
				{
					res = res.split(' ');
					for(var k=0; k<=j; k++)
					{
						if(res[k]) result[i+k] = withtone ? res[k] : pinyinUtil.removeTone(res[k]);
					}
					break;
				}
			}
		}
		// �����һ����Ϊ�˷�ֹ���ִʿ�����Ҳû�а����Ķ����ִ���
		for(var i=0; i<result.length; i++)
		{
			result[i] = result[i].replace(/ .*$/g, '');
		}
		return result.join(splitter);
	}

	// ������ȥ��
	function simpleUnique(array)
	{
		var result = [];
		var hash = {};
		for(var i=0; i<array.length; i++)
		{
			var key = (typeof array[i]) + array[i];
			if(!hash[key])
			{
				result.push(array[i]);
				hash[key] = true;
			}
		}
		return result;
	}

	pinyinUtil.parseDict();
	pinyinUtil.dict = dict;
	window.pinyinUtil = pinyinUtil;

});