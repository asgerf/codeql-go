/**
 * @kind path-problem
 */

import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.ExternalFlow
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation
import TestUtilities.InlineFlowTest

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; signature; ext; input; output; kind`
        "github.com/nonexistent/test;T;false;StepArgRes;;;Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;T;false;StepArgRes1;;;Argument[0];ReturnValue[1];taint",
        "github.com/nonexistent/test;T;false;StepArgArg;;;Argument[0];Argument[1];taint",
        "github.com/nonexistent/test;T;false;StepArgQual;;;Argument[0];Argument[-1];taint",
        "github.com/nonexistent/test;T;false;StepQualRes;;;Argument[-1];ReturnValue;taint",
        "github.com/nonexistent/test;T;false;StepQualArg;;;Argument[-1];Argument[0];taint",
        "github.com/nonexistent/test;;false;StepArgResNoQual;;;Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgResArrayContent;;;Argument[0];ArrayElement of ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgArrayContentRes;;;ArrayElement of Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgResCollectionContent;;;Argument[0];Element of ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgCollectionContentRes;;;Element of Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgResMapKeyContent;;;Argument[0];MapKey of ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgMapKeyContentRes;;;MapKey of Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgResMapValueContent;;;Argument[0];MapValue of ReturnValue;taint",
        "github.com/nonexistent/test;;false;StepArgMapValueContentRes;;;MapValue of Argument[0];ReturnValue;taint",
        "github.com/nonexistent/test;;false;GetElement;;;Element of Argument[0];ReturnValue;value",
        "github.com/nonexistent/test;;false;GetMapKey;;;MapKey of Argument[0];ReturnValue;value",
        "github.com/nonexistent/test;;false;SetElement;;;Argument[0];Element of ReturnValue;value",
        "github.com/nonexistent/test;C;false;Get;;;Field[github.com/nonexistent/test.C.F] of Argument[-1];ReturnValue;value",
        "github.com/nonexistent/test;C;false;Set;;;Argument[0];Field[github.com/nonexistent/test.C.F] of Argument[-1];value",
      ]
  }
}

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; output; kind`
        "github.com/nonexistent/test;A;false;Src1;;;ReturnValue;qltest"
      ]
  }
}

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; input; kind`
        "github.com/nonexistent/test;B;false;Sink1;;;Argument[0];qltest"
      ]
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "external-flow-test" }

  override predicate isSource(DataFlow::Node src) { sourceNode(src, "qltest") }

  override predicate isSink(DataFlow::Node src) { sinkNode(src, "qltest") }
}

class ExternalFlowTest extends InlineFlowTest {
  override DataFlow::Configuration getValueFlowConfig() { none() }

  override DataFlow::Configuration getTaintFlowConfig() { result = any(Config config) }
}
