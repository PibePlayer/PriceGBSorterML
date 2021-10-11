module main

import net.http
import x.json2
import regex
import os

struct HDD {
	name string
	price f32
	size int
	permalink string
}

fn main() {
	println('Hello World!')
	mut request := http.Request{
		url: "https://api.mercadolibre.com/sites/MLA/search?category=MLA1672",
		method: http.Method.get
	}
	request.add_header(http.CommonHeader.authorization, "Bearer TG-6163150ead3e6b000762d365-134063224")
	response := request.do() ?

	query := r'([\d]+(?:\.|,[\d]{1,4})?)\s*(?P<denom>(TB)|(GB))'
	mut re := regex.regex_opt(query) or { panic(err) }
	println(re.get_query())
	//re.compile_opt() ?

	raw := json2.raw_decode(response.text) ?
	mapped := raw.as_map()
	//println(response.text)

	mut str := ""
	for product in mapped['results']?.arr() {
		//println(mapped['results']?.arr())
		str = product.as_map()['title']?.str().to_upper()
		println(str)
		start, end := re.find(str)
		println(start)
		println(end)
		if start != -1 {
			println(str[start..end])
		}
	}
	os.write_file("/data/data/com.termux/files/home/PriceGBSorterML/test.json", response.text) ?
	//println(response.text)
}
