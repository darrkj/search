/**
  https://github.com/utcompling/applied-nlp/wiki/TopicModel-Exercise

  http://garysieling.com/blog/extracting-pdf-text-with-scala

  ./scala -classpath tika.jar-app-1.4.jar

*/


import java.io.FileOutputStream
import scala.Console
import java.io._
import org.apache.tika.parser.pdf._
import org.apache.tika.metadata._
import org.apache.tika.parser._
import org.xml.sax._

object pdfHandler extends ContentHandler {
  def characters(ch : Array[Char], start: Int, length: Int) {
    println(new String(ch))
  }
  def endDocument() {}
  def endElement(uri: String, localName: String, qName: String) {}
  def endPrefixMapping(prefix: String) {}
  def ignorableWhitespace(ch: Array[Char], start: Int, length: Int) {}
  def processingInstruction(target: String, data: String) {}
  def setDocumentLocator(locator: Locator) {}
  def skippedEntity(name: String) {}
  def startDocument() {}
  def startElement(uri: String, localName: String, qName: String, atts: Attributes) {}
  def startPrefixMapping(prefix: String, uri: String) {}
}

import scala.Console
val x = new File("../../mltm/Files").list
val id = 1 until x.length
for (i <- id) {
  Console.setOut(new FileOutputStream("../../mltm/clean/" + x(i) + ".txt"))

  val file = "../../mltm/Files/" + x(i)
 
  val pdf : PDFParser = new PDFParser();
 
  val stream : InputStream = new FileInputStream(file)
  val handler : ContentHandler = pdfHandler
  val metadata : Metadata = new Metadata()
  val context : ParseContext = new ParseContext()
 
  pdf.parse(stream, handler, metadata, context)
 
  stream.close()
}