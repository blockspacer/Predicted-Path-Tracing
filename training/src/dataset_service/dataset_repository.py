"""
Module for DataRepositories which can get datasets
"""
from abc import ABC, abstractmethod
from pathlib import Path
import numpy as np
from .dataset import CombinedDataset


class DatasetRepositoryBase(ABC):
    """
    Abstract class for getting datasets
    """

    @abstractmethod
    def load_dataset(self) -> CombinedDataset:
        """
        Loads the dataset
        """


class DummyDatasetRepository(DatasetRepositoryBase):
    """
    Returns dummy data
    """

    def __init__(self, samples: int):
        self.samples = samples
        self.width = 2
        self.height = 2

    def load_dataset(self) -> CombinedDataset:
        names = [f"{i}" for i in range(self.samples)]
        renders = [
            np.random.rand(self.width, self.height, 5)
            for _ in range(self.samples)
        ]
        images = [
            renders[i][:, :, :3] * 0.8 +
            (np.random.rand(self.width, self.height, 3) * 0.2)
            for i in range(self.samples)
        ]

        dataset = CombinedDataset(
            dataset_path=Path(),
            names=names,
            images=images,
            renders=renders,
        )
        return dataset
