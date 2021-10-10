module main

import net.http
import x.json2

fn main() {
	println('Hello World!')
	mut raw := json2.raw_decode('{ "a": "b", "b": "c"}') ?
	//header := http.Header{}
	//header.add(http.CommonHeader.authorization, "Bearer test")
	mut request := http.Request{
		url: "https://api.mercadolibre.com/sites/MLA/search?q=Disco%20Duro",
		method: http.Method.get
	}
	request.add_header(http.CommonHeader.authorization, "Bearer TG-6163150ead3e6b000762d365-134063224")
	response := request.do() ?
	raw = json2.raw_decode(response.text) ?
	mapped := raw.as_map()
	println(response.text)

	for product in mapped['results']?.arr() {
		//println(mapped['results']?.arr())
		println(product.as_map()['title']?.str())
	}
	//println(response.text)
}
