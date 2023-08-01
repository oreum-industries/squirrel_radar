# cli.py
"""CLI to manage ResEvol Engine (prepare, train, forecast, publish)"""
from pathlib import Path
from typing import Optional

import confuse
import typer
from rich.progress import Progress, SpinnerColumn, TextColumn

from squirrel_radar import create_radar

__all__ = ['create']

helpd = dict(
    app='CLI to create Squirrel Radar',
    project_name='Project name e.g. "Company, Month Year"',
    scores='Scores must be an string of values of length 6, each score in range [0, 5], starting with Org Maturity, e.g. "123455"',
)

kws_exrd = dict(exists=True, readable=True)
app = typer.Typer(help=helpd['app'])


@app.command()
def create(
    project_name: str = typer.Option(None, help=helpd['project_name']),
    scores: str = typer.Option(..., help=helpd['scores']),
):
    """Create Radar Plot"""
    scoresl = [int(t) for t in str(scores)]
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        transient=True,
    ) as progress:
        t0 = progress.add_task(description="Create Radar Plot", total=1)
        create_radar(scores=scoresl, project_name=project_name)
        progress.advance(t0, advance=1)


if __name__ == '__main__':
    app()
