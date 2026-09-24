"""Generates docs/architecture.drawio for the Managed Backup Solution project using drawpyo.

Run with: python3 scripts/generate_diagram.py
"""
import os

import drawpyo

OUTPUT_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "docs")

AWS4_BASE = (
    "sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;strokeColor=none;"
    "dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;"
    "fontSize=11;fontStyle=0;aspect=fixed;pointerEvents=1;"
)


def aws_style(icon_name, fill_color):
    return f"{AWS4_BASE}fillColor={fill_color};shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.{icon_name};"


def add_node(page, name, x, y, icon_name, fill_color, width=64, height=64):
    node = drawpyo.diagram.Object(page=page, value=name)
    node.position = (x, y)
    node.geometry.width = width
    node.geometry.height = height
    node.apply_style_string(aws_style(icon_name, fill_color))
    return node


def add_edge(page, source, target, label=None):
    edge = drawpyo.diagram.Edge(page=page, source=source, target=target, label=label)
    edge.waypoints = "orthogonal"
    edge.endArrow = "block"
    edge.startArrow = "none"
    edge.strokeColor = "#545B64"
    return edge


def build_diagram():
    file = drawpyo.File()
    file.file_name = "architecture.drawio"
    file.file_path = OUTPUT_DIR

    page = drawpyo.Page(file=file)
    page.name = "Managed Backup Solution"

    web_server = add_node(page, "Web Server\nInstance", 40, 40, "ec2", "#ED7100")
    sql_server = add_node(page, "SQL Server\nInstance", 200, 40, "ec2", "#ED7100")

    efs = add_node(page, "Shared File\nStorage (EFS)", 40, 180, "elastic_file_system", "#7AA116")
    ebs_a = add_node(page, "Block Storage\n(EBS)", 200, 180, "elastic_block_store", "#7AA116")
    ebs_b = add_node(page, "Block Storage\n(EBS)", 360, 180, "elastic_block_store", "#7AA116")
    s3 = add_node(page, "Data Lake\nRaw Data (S3)", 520, 180, "bucket", "#7AA116")

    backup_plan = add_node(page, "Daily Backup\nPlan", 200, 320, "backup", "#7AA116")
    backup_vault = add_node(page, "Recovery Points\n(Backup Vault)", 400, 320, "backup", "#7AA116")

    add_edge(page, web_server, efs)
    add_edge(page, web_server, ebs_a)
    add_edge(page, sql_server, ebs_b)

    add_edge(page, efs, backup_plan)
    add_edge(page, ebs_a, backup_plan)
    add_edge(page, ebs_b, backup_plan)
    add_edge(page, s3, backup_plan)
    add_edge(page, backup_plan, backup_vault)

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    file.write()
    print(f"Wrote {os.path.join(OUTPUT_DIR, file.file_name)}")


if __name__ == "__main__":
    build_diagram()
